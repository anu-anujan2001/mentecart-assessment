import Service from "../models/service.model";

export const createService = async (data: any) => {
  return await Service.create(data);
};

export const getServices = async (
  search: string,
  category: string,
  page: number,
  limit: number,
) => {
  const query: any = {};

  if (search) {
    query.title = {
      $regex: search,

      $options: "i",
    };
  }

  if (category) {
    query.category = category;
  }

  const total = await Service.countDocuments(query);

  const data = await Service.find(query)

    .skip((page - 1) * limit)

    .limit(limit);

  return {
    data,

    total,

    hasMore: page * limit < total,
  };
};

export const getServiceById = async (id: string) => {
  return await Service.findById(id);
};
