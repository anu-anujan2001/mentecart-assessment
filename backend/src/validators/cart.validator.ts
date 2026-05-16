import { z } from "zod";

export const addCartSchema = z.object({
  serviceId: z.string(),

  quantity: z.number(),

  date: z.string(),

  startTime: z.string(),
});
