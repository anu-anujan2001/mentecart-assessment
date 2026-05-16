import '../../core/network/dio_client.dart';

class CartRemoteDatasource {
  Future<dynamic> getCart() async {
    final response = await DioClient.dio.get('/cart');
    return response.data;
  }

  Future<dynamic> addItem({
    required String serviceId,
    required String date,
    required String startTime,
    required int quantity,
  }) async {
    final response = await DioClient.dio.post('/cart/items', data: {
      'serviceId': serviceId,
      'date': date,
      'startTime': startTime,
      'quantity': quantity,
    });
    return response.data;
  }

  Future<dynamic> updateItem(
    String itemId, {
    int? quantity,
    String? date,
    String? startTime,
  }) async {
    final response = await DioClient.dio.put('/cart/items/$itemId', data: {
      if (quantity != null) 'quantity': quantity,
      if (date != null) 'date': date,
      if (startTime != null) 'startTime': startTime,
    });
    return response.data;
  }

  Future<dynamic> removeItem(String itemId) async {
    final response = await DioClient.dio.delete('/cart/items/$itemId');
    return response.data;
  }
}
