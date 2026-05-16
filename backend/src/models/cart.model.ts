import mongoose from "mongoose";

const CART_EXPIRY_MINUTES = 15;

const cartItemSchema = new mongoose.Schema({
  service: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Service",
  },
  quantity: {
    type: Number,
    default: 1,
  },
  date: {
    type: String,
  },
  startTime: {
    type: String,
  },
  price: {
    type: Number,
  },
  addedAt: {
    type: Date,
    default: Date.now,
  },
});

const cartSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      unique: true,
    },
    items: [cartItemSchema],
  },
  {
    timestamps: true,
  }
);

// Remove expired items before returning
cartSchema.methods.removeExpiredItems = function () {
  const now = new Date();
  this.items = this.items.filter((item: any) => {
    const addedAt = new Date(item.addedAt);
    const diffMinutes = (now.getTime() - addedAt.getTime()) / 1000 / 60;
    return diffMinutes < CART_EXPIRY_MINUTES;
  });
};

export default mongoose.model("Cart", cartSchema);
