import { Response, NextFunction } from "express";
import * as cartService from "../services/cart.service";

export const getCart = async (req: any, res: Response, next: NextFunction) => {
  try {
    const cart = await cartService.getCart(req.user.id);
    res.json(cart);
  } catch (error) {
    next(error);
  }
};

export const addToCart = async (req: any, res: Response, next: NextFunction) => {
  try {
    const cart = await cartService.addToCart(req.user.id, req.body);
    res.status(201).json(cart);
  } catch (error) {
    next(error);
  }
};

export const updateCartItem = async (req: any, res: Response, next: NextFunction) => {
  try {
    const cart = await cartService.updateCartItem(
      req.user.id,
      req.params.itemId,
      req.body
    );
    res.json(cart);
  } catch (error) {
    next(error);
  }
};

export const deleteCartItem = async (req: any, res: Response, next: NextFunction) => {
  try {
    const cart = await cartService.deleteCartItem(req.user.id, req.params.itemId);
    res.json(cart);
  } catch (error) {
    next(error);
  }
};
