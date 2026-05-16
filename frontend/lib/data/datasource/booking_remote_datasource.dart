import '../../core/network/dio_client.dart';

class BookingRemoteDatasource {
  Future<dynamic> checkout(String paymentMethod) async {
    final response = await DioClient.dio.post('/booking/checkout', data: {
      'paymentMethod': paymentMethod,
    });
    return response.data;
  }

  Future<List<dynamic>> getBookings() async {
    final response = await DioClient.dio.get('/booking');
    return response.data as List<dynamic>;
  }

  Future<dynamic> getBookingById(String id) async {
    final response = await DioClient.dio.get('/booking/$id');
    return response.data;
  }

  Future<dynamic> cancelBooking(String id) async {
    final response = await DioClient.dio.post('/booking/$id/cancel');
    return response.data;
  }
}
