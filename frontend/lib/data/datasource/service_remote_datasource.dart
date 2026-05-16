import '../../core/network/dio_client.dart';

class ServiceRemoteDatasource {
  Future<Map<String, dynamic>> getServices({
    String? search,
    String? category,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (search != null && search.isNotEmpty) 'search': search,
      if (category != null && category.isNotEmpty) 'category': category,
    };
    final response = await DioClient.dio.get('/service', queryParameters: queryParams);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getServiceById(String id) async {
    final response = await DioClient.dio.get('/service/$id');
    return response.data as Map<String, dynamic>;
  }
}
