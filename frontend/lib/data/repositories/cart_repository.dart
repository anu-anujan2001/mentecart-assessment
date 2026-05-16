import '../datasource/cart_remote_datasource.dart';
import '../models/cart_model.dart';

class CartRepository {
  final CartRemoteDatasource datasource;
  CartRepository(this.datasource);

  Future<CartModel?> getCart() async {
    final data = await datasource.getCart();
    if (data == null) return null;
    return CartModel.fromJson(data);
  }

  Future<CartModel> addItem({
    required String serviceId,
    required String date,
    required String startTime,
    required int quantity,
  }) async {
    final data = await datasource.addItem(
      serviceId: serviceId,
      date: date,
      startTime: startTime,
      quantity: quantity,
    );
    return CartModel.fromJson(data);
  }

  Future<CartModel> updateItem(String itemId,
      {int? quantity, String? date, String? startTime}) async {
    final data = await datasource.updateItem(itemId,
        quantity: quantity, date: date, startTime: startTime);
    return CartModel.fromJson(data);
  }

  Future<CartModel> removeItem(String itemId) async {
    final data = await datasource.removeItem(itemId);
    return CartModel.fromJson(data);
  }
}
