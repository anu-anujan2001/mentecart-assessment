import express from 'express';
import { getMe, login, register } from '../controllers/auth.controller';
import { protectRoute } from '../middleware/auth.middleware';

const router = express.Router();
/**
 * @swagger
 * /auth/register:
 *   post:
 *     summary: Register user
 */
router.post('/register', register);
/**
 * @swagger
 * /auth/login:
 *   post:
 *     summary: Login user
 */
router.post('/login', login);

router.get('/me', protectRoute, getMe);

export default router;