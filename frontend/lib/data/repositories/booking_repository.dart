import '../datasource/booking_remote_datasource.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final BookingRemoteDatasource datasource;
  BookingRepository(this.datasource);

  Future<BookingModel> checkout(String paymentMethod) async {
    final data = await datasource.checkout(paymentMethod);
    return BookingModel.fromJson(data);
  }

  Future<List<BookingModel>> getBookings() async {
    final list = await datasource.getBookings();
    return list.map((b) => BookingModel.fromJson(b)).toList();
  }

  Future<BookingModel> getBookingById(String id) async {
    final data = await datasource.getBookingById(id);
    return BookingModel.fromJson(data);
  }

  Future<BookingModel> cancelBooking(String id) async {
    final data = await datasource.cancelBooking(id);
    return BookingModel.fromJson(data);
  }
}
