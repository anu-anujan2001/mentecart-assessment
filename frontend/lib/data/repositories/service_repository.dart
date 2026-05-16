import '../datasource/service_remote_datasource.dart';
import '../models/service_model.dart';

class ServiceRepository {
  final ServiceRemoteDatasource datasource;
  ServiceRepository(this.datasource);

  Future<({List<ServiceModel> data, int total, bool hasMore})> getServices({
    String? search,
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    final json = await datasource.getServices(
      search: search,
      category: category,
      page: page,
      limit: limit,
    );
    final data = (json['data'] as List<dynamic>)
        .map((s) => ServiceModel.fromJson(s))
        .toList();
    return (
      data: data,
      total: json['total'] as int,
      hasMore: json['hasMore'] as bool,
    );
  }

  Future<ServiceModel> getServiceById(String id) async {
    final json = await datasource.getServiceById(id);
    return ServiceModel.fromJson(json);
  }
}
