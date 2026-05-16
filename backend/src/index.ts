import express from "express";
import cors from "cors";
import morgan from "morgan";  
import dotenv from "dotenv";
import { connectDB } from "./lib/db";
import authRoutes from "./routes/auth.routes";
import serviceRoute from './routes/service.routes';
import cartRoutes from './routes/cart.routes';
import bookingRoutes from './routes/booking.routes';
import { errorHandler } from "./middleware/error.middleware";
import swaggerUi from "swagger-ui-express";
import swaggerSpec from "./docs/swagger";


dotenv.config();

const app = express();


app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan("dev"));

app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));
app.use("/api/auth", authRoutes);
app.use("/api/service", serviceRoute);
app.use("/api/cart", cartRoutes);
app.use("/api/booking", bookingRoutes);


app.use(errorHandler);

app.listen(process.env.PORT, () => {
  console.log(`Server is running on port ${process.env.PORT}`);
  connectDB();
});
