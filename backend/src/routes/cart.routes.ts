import { Router } from "express";

import * as cartController from "../controllers/cart.controller";

import { protectRoute } from "../middleware/auth.middleware";

const router = Router();

router.get(
  "/",

  protectRoute,

  cartController.getCart,
);

router.post(
  "/items",

  protectRoute,

  cartController.addToCart,
);

router.put(
  "/items/:itemId",

  protectRoute,

  cartController.updateCartItem,
);

router.delete(
  "/items/:itemId",

  protectRoute,

  cartController.deleteCartItem,
);

export default router;
