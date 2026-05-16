import { Response, NextFunction } from "express";
import * as bookingService from "../services/booking.service";

export const checkout = async (req: any, res: Response, next: NextFunction) => {
  try {
    const booking = await bookingService.checkout(req.user.id, req.body.paymentMethod);
    res.status(201).json(booking);
  } catch (error) {
    next(error);
  }
};

export const getBookings = async (req: any, res: Response, next: NextFunction) => {
  try {
    const bookings = await bookingService.getBookings(req.user.id);
    res.json(bookings);
  } catch (error) {
    next(error);
  }
};

export const getBookingById = async (req: any, res: Response, next: NextFunction) => {
  try {
    const booking = await bookingService.getBookingById(req.user.id, req.params.id);
    res.json(booking);
  } catch (error) {
    next(error);
  }
};

export const cancelBooking = async (req: any, res: Response, next: NextFunction) => {
  try {
    const booking = await bookingService.cancelBooking(req.user.id, req.params.id);
    res.json(booking);
  } catch (error) {
    next(error);
  }
};
