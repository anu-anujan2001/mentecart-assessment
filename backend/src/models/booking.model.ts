import mongoose from "mongoose";

const statusHistorySchema = new mongoose.Schema(
  {
    status: { type: String },
    timestamp: { type: Date, default: Date.now },
  },
  { _id: false }
);

const bookingSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    items: [
      {
        service: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "Service",
        },
        quantity: Number,
        date: String,
        startTime: String,
        price: Number,
      },
    ],
    totalAmount: {
      type: Number,
    },
    paymentMethod: {
      type: String,
      enum: ["cash", "card"],
    },
    paymentStatus: {
      type: String,
      enum: ["pending", "paid", "failed"],
      default: "pending",
    },
    status: {
      type: String,
      enum: ["pending", "confirmed", "completed", "cancelled", "failed"],
      default: "pending",
    },
    statusHistory: [statusHistorySchema],
  },
  {
    timestamps: true,
  }
);

export default mongoose.model("Booking", bookingSchema);
