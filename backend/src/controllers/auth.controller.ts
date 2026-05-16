import { Request, Response, NextFunction } from 'express';
import * as authService from '../services/auth.service';
import { loginSchema, registerSchema } from '../validators/auth.validator';
import User from '../models/user.model';

export const register = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { name, email, password } = registerSchema.parse(req.body);
    const user = await authService.register(name, email, password);
    res.status(201).json({ user });
  } catch (error: any) {
    next(error);
  }
};

export const login = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { email, password } = loginSchema.parse(req.body);
    const { user, token } = await authService.login(email, password);
    res.json({ user, token });
  } catch (error: any) {
    next(error);
  }
};

export const getMe = async (req: any, res: Response, next: NextFunction) => {
  try {
    const user = await User.findById(req.user.id).select('-password');
    if (!user) {
      const error: any = new Error('User not found');
      error.statusCode = 404;
      throw error;
    }
    res.json(user);
  } catch (error: any) {
    next(error);
  }
};
