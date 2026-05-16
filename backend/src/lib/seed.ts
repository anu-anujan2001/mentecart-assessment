import mongoose from "mongoose";
import dotenv from "dotenv";
import Service from "../models/service.model";

dotenv.config();

const today = new Date();
const fmt = (d: Date) => d.toISOString().split("T")[0];

const days = [0, 1, 2, 3, 4].map((i) => {
  const d = new Date(today);
  d.setDate(today.getDate() + i);
  return fmt(d);
});

const makeSlots = (capacity: number) =>
  days.flatMap((date) => [
    { date, startTime: "09:00", endTime: "10:00", remainingCapacity: capacity },
    { date, startTime: "11:00", endTime: "12:00", remainingCapacity: capacity },
    { date, startTime: "14:00", endTime: "15:00", remainingCapacity: capacity },
    { date, startTime: "16:00", endTime: "17:00", remainingCapacity: capacity },
  ]);

const services = [
  {
    title: "Home Deep Cleaning",
    description: "Professional deep cleaning for your home. Includes kitchen, bathrooms, bedrooms, and living areas.",
    price: 4500,
    duration: 180,
    category: "Cleaning",
    image: "https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=400",
    capacityPerSlot: 5,
    slots: makeSlots(5),
  },
  {
    title: "Plumbing Repair",
    description: "Expert plumbing services for leaks, pipe installations, and drainage issues.",
    price: 2500,
    duration: 60,
    category: "Plumbing",
    image: "https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?w=400",
    capacityPerSlot: 3,
    slots: makeSlots(3),
  },
  {
    title: "Math Tutoring",
    description: "One-on-one math tutoring for all levels. Algebra, calculus, and more.",
    price: 1500,
    duration: 60,
    category: "Tutoring",
    image: "https://images.unsplash.com/photo-1596496050827-8299e0220de1?w=400",
    capacityPerSlot: 1,
    slots: makeSlots(1),
  },
  {
    title: "Haircut & Styling",
    description: "Professional haircut and styling services at your doorstep.",
    price: 800,
    duration: 45,
    category: "Beauty",
    image: "https://images.unsplash.com/photo-1562322140-8baeececf3df?w=400",
    capacityPerSlot: 2,
    slots: makeSlots(2),
  },
  {
    title: "Electrical Wiring Inspection",
    description: "Certified electrician inspects and fixes wiring, switches, and sockets.",
    price: 3000,
    duration: 90,
    category: "Electrical",
    image: "https://images.unsplash.com/photo-1621905251918-48416bd8575a?w=400",
    capacityPerSlot: 4,
    slots: makeSlots(4),
  },
  {
    title: "AC Servicing",
    description: "Complete air conditioner cleaning, gas refill, and maintenance.",
    price: 3500,
    duration: 120,
    category: "Appliance",
    image: "https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=400",
    capacityPerSlot: 3,
    slots: makeSlots(3),
  },
  {
    title: "Facial & Skin Care",
    description: "Relaxing facial treatment with premium skincare products.",
    price: 2000,
    duration: 60,
    category: "Beauty",
    image: "https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=400",
    capacityPerSlot: 2,
    slots: makeSlots(2),
  },
  {
    title: "English Language Tutoring",
    description: "Improve your English speaking, writing, and grammar with a certified tutor.",
    price: 1200,
    duration: 60,
    category: "Tutoring",
    image: "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=400",
    capacityPerSlot: 1,
    slots: makeSlots(1),
  },
];

const seed = async () => {
  await mongoose.connect(process.env.MONGODB_URI!);
  await Service.deleteMany({});
  await Service.insertMany(services);
  console.log(`✅ Seeded ${services.length} services`);
  await mongoose.disconnect();
};

seed().catch((err) => {
  console.error(err);
  process.exit(1);
});
