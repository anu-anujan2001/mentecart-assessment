import { z } from "zod";

export const createServiceSchema = z.object({
  title: z.string(),

  description: z.string(),

  price: z.number(),

  duration: z.number(),

  category: z.string(),

  image: z.string(),

  capacityPerSlot: z.number(),
});
