import { Router } from "express";

import { createService, getServiceById, getServices } from "../controllers/service.controller";

import { protectRoute } from "../middleware/auth.middleware";
import { allowRoles } from "../middleware/role.middleware";

const router = Router();

router.post( "/",protectRoute,allowRoles("admin"),createService);
/**
 * @swagger
 * /services:
 *   get:
 *     summary: Get services
 */
router.get("/", getServices);

router.get("/:id",getServiceById);

export default router;
