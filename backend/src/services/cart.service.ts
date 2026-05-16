import Cart from "../models/cart.model";
import Service from "../models/service.model";

export const getCart = async (userId: string) => {
  let cart = await Cart.findOne({ user: userId }).populate("items.service");
  if (cart) {
    (cart as any).removeExpiredItems();
    await cart.save();
    cart = await Cart.findOne({ user: userId }).populate("items.service");
  }
  return cart;
};

export const addToCart = async (userId: string, data: any) => {
  let cart = await Cart.findOne({ user: userId });

  if (!cart) {
    cart = await Cart.create({ user: userId, items: [] });
  }

  // Remove expired items first
  (cart as any).removeExpiredItems();

  const service = await Service.findById(data.serviceId);
  if (!service) {
    const error: any = new Error("Service not found");
    error.statusCode = 404;
    throw error;
  }

  // Check slot exists and has capacity
  const slot = service.slots.find(
    (s: any) => s.date === data.date && s.startTime === data.startTime
  );
  if (!slot) {
    const error: any = new Error("Slot not found for this service");
    error.statusCode = 404;
    throw error;
  }
  if ((slot as any).remainingCapacity < data.quantity) {
    const error: any = new Error("Not enough capacity for this slot");
    error.statusCode = 409;
    throw error;
  }

  const existing = cart.items.find(
    (item: any) =>
      item.service.toString() === data.serviceId &&
      item.date === data.date &&
      item.startTime === data.startTime
  );

  if (existing) {
    existing.quantity += data.quantity;
  } else {
    cart.items.push({
      service: data.serviceId,
      quantity: data.quantity,
      date: data.date,
      startTime: data.startTime,
      price: service.price,
      addedAt: new Date(),
    } as any);
  }

  await cart.save();
  return await Cart.findOne({ user: userId }).populate("items.service");
};

export const updateCartItem = async (
  userId: string,
  itemId: string,
  data: any
) => {
  const cart = await Cart.findOne({ user: userId });
  if (!cart) {
    const error: any = new Error("Cart not found");
    error.statusCode = 404;
    throw error;
  }

  const item = cart.items.id(itemId);
  if (!item) {
    const error: any = new Error("Cart item not found");
    error.statusCode = 404;
    throw error;
  }

  if (data.quantity !== undefined) (item as any).quantity = data.quantity;
  if (data.date !== undefined) (item as any).date = data.date;
  if (data.startTime !== undefined) (item as any).startTime = data.startTime;

  await cart.save();
  return await Cart.findOne({ user: userId }).populate("items.service");
};

export const deleteCartItem = async (userId: string, itemId: string) => {
  const cart = await Cart.findOne({ user: userId });
  if (!cart) {
    const error: any = new Error("Cart not found");
    error.statusCode = 404;
    throw error;
  }
  cart.items.pull(itemId);
  await cart.save();
  return await Cart.findOne({ user: userId }).populate("items.service");
};
