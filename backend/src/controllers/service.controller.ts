import { Request, Response, NextFunction } from "express";
import * as serviceService from "../services/service.service";
import { createServiceSchema } from "../validators/service.validator";

export const createService = async (req: Request, res: Response, next: NextFunction) => {
  try {
    createServiceSchema.parse(req.body);
    const service = await serviceService.createService(req.body);
    res.status(201).json(service);
  } catch (error) {
    next(error);
  }
};

export const getServices = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const services = await serviceService.getServices(
      req.query.search as string,
      req.query.category as string,
      Number(req.query.page) || 1,
      Number(req.query.limit) || 10
    );
    res.json(services);
  } catch (error) {
    next(error);
  }
};

export const getServiceById = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const service = await serviceService.getServiceById(req.params.id as string);
    if (!service) {
      const error: any = new Error("Service not found");
      error.statusCode = 404;
      throw error;
    }
    res.json(service);
  } catch (error) {
    next(error);
  }
};
