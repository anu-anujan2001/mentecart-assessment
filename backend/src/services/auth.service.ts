import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import User from "../models/user.model";

export const register = async (name: string, email: string, password: string) => {
  const existingUser = await User.findOne({ email });
  if (existingUser) {
    const error: any = new Error("Email already taken");
    error.statusCode = 409;
    throw error;
  }

  const hashedPassword = await bcrypt.hash(password, 10);
  const user = await User.create({ name, email, password: hashedPassword });

  const safeUser = { _id: user._id, name: user.name, email: user.email, role: user.role };
  return safeUser;
};

export const login = async (email: string, password: string) => {
  const user = await User.findOne({ email });
  if (!user) {
    const error: any = new Error("Invalid credentials");
    error.statusCode = 401;
    throw error;
  }

  const isPasswordValid = await bcrypt.compare(password, user.password);
  if (!isPasswordValid) {
    const error: any = new Error("Invalid credentials");
    error.statusCode = 401;
    throw error;
  }

  const token = jwt.sign(
    { id: user._id, role: user.role },
    process.env.JWT_SECRET as string,
    { expiresIn: "24h" }
  );

  const safeUser = { _id: user._id, name: user.name, email: user.email, role: user.role };
  return { user: safeUser, token };
};
