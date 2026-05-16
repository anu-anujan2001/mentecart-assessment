import mongoose from "mongoose";

const serviceSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
    },

    description: {
      type: String,
      required: true,
    },

    price: {
      type: Number,
      required: true,
    },

    duration: {
      type: Number,
      required: true,
    },

    category: {
      type: String,
      required: true,
    },

    image: {
      type: String,
      required: true,
    },

    capacityPerSlot: {
      type: Number,
      required: true,
    },

    slots: [
      {
        date: {
          type: String,
        },

        startTime: {
          type: String,
        },

        endTime: {
          type: String,
        },

        remainingCapacity: {
          type: Number,
        },
      },
    ],
  },

  {
    timestamps: true,
  },
);

export default mongoose.model("Service", serviceSchema);
