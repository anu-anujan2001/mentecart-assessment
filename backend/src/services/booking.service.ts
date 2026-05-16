import mongoose from "mongoose";
import Booking from "../models/booking.model";
import Cart from "../models/cart.model";
import Service from "../models/service.model";

const MAX_BOOKINGS_PER_DAY = 3;

export const checkout = async (
  userId: string,
  paymentMethod: "cash" | "card"
) => {
  const cart = await Cart.findOne({ user: userId }).populate("items.service");

  if (!cart || cart.items.length === 0) {
    const error: any = new Error("Cart is empty");
    error.statusCode = 400;
    throw error;
  }

  // Check daily booking limit
  const todayStart = new Date();
  todayStart.setHours(0, 0, 0, 0);
  const todayEnd = new Date();
  todayEnd.setHours(23, 59, 59, 999);

  const todayBookings = await Booking.countDocuments({
    user: userId,
    createdAt: { $gte: todayStart, $lte: todayEnd },
    status: { $nin: ["cancelled", "failed"] },
  });

  if (todayBookings >= MAX_BOOKINGS_PER_DAY) {
    const error: any = new Error(`Booking limit reached: max ${MAX_BOOKINGS_PER_DAY} bookings per day`);
    error.statusCode = 409;
    throw error;
  }

  // Atomic capacity check & decrement for each item
  for (const item of cart.items as any[]) {
    const serviceId = item.service._id ?? item.service;
    const result = await Service.findOneAndUpdate(
      {
        _id: serviceId,
        "slots.date": item.date,
        "slots.startTime": item.startTime,
        "slots.remainingCapacity": { $gte: item.quantity },
      },
      {
        $inc: { "slots.$.remainingCapacity": -item.quantity },
      },
      { new: true }
    );

    if (!result) {
      const error: any = new Error(
        `No available capacity for service on ${item.date} at ${item.startTime}`
      );
      error.statusCode = 409;
      throw error;
    }
  }

  const totalAmount = cart.items.reduce(
    (sum: number, item: any) => sum + item.price * item.quantity,
    0
  );

  const booking = await Booking.create({
    user: userId,
    items: cart.items.map((i: any) => ({
      service: i.service._id ?? i.service,
      quantity: i.quantity,
      date: i.date,
      startTime: i.startTime,
      price: i.price,
    })),
    totalAmount,
    paymentMethod,
    paymentStatus: paymentMethod === "cash" ? "paid" : "pending",
    status: paymentMethod === "cash" ? "confirmed" : "pending",
    statusHistory: [
      {
        status: paymentMethod === "cash" ? "confirmed" : "pending",
        timestamp: new Date(),
      },
    ],
  });

  // Clear cart
  cart.items.splice(0, cart.items.length);
  await cart.save();

  return booking;
};

export const getBookings = async (userId: string) => {
  return await Booking.find({ user: userId })
    .populate("items.service")
    .sort({ createdAt: -1 });
};

export const getBookingById = async (userId: string, bookingId: string) => {
  const booking = await Booking.findOne({ _id: bookingId, user: userId }).populate(
    "items.service"
  );
  if (!booking) {
    const error: any = new Error("Booking not found");
    error.statusCode = 404;
    throw error;
  }
  return booking;
};

export const cancelBooking = async (userId: string, bookingId: string) => {
  const booking = await Booking.findOne({ _id: bookingId, user: userId });

  if (!booking) {
    const error: any = new Error("Booking not found");
    error.statusCode = 404;
    throw error;
  }

  const nonCancellable = ["cancelled", "completed", "failed"];
  if (nonCancellable.includes(booking.status)) {
    const error: any = new Error(`Cannot cancel a booking with status: ${booking.status}`);
    error.statusCode = 409;
    throw error;
  }

  // Release capacity back
  for (const item of booking.items as any[]) {
    await Service.findOneAndUpdate(
      {
        _id: item.service,
        "slots.date": item.date,
        "slots.startTime": item.startTime,
      },
      {
        $inc: { "slots.$.remainingCapacity": item.quantity },
      }
    );
  }

  booking.status = "cancelled";
  booking.statusHistory.push({ status: "cancelled", timestamp: new Date() });
  await booking.save();

  return booking;
};
