import { Router } from "express";

import {
  checkout,
  getBookings,
  getBookingById,
  cancelBooking,
} from "../controllers/booking.controller";

import { protectRoute } from "../middleware/auth.middleware";

const router = Router();

router.post(
  "/checkout",

  protectRoute,

  checkout,
);

router.get(
  "/",

  protectRoute,

  getBookings,
);

router.get(
  "/:id",

  protectRoute,

  getBookingById,
);

router.post(
  "/:id/cancel",

  protectRoute,

  cancelBooking,
);

export default router;
