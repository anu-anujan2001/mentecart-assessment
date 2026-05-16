import 'service_model.dart';

class CartItemModel {
  final String id;
  final ServiceModel? service;
  final int quantity;
  final String date;
  final String startTime;
  final double price;

  CartItemModel({
    required this.id,
    this.service,
    required this.quantity,
    required this.date,
    required this.startTime,
    required this.price,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: json['_id'] ?? '',
        service: json['service'] is Map<String, dynamic>
            ? ServiceModel.fromJson(json['service'])
            : null,
        quantity: json['quantity'] ?? 1,
        date: json['date'] ?? '',
        startTime: json['startTime'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
      );

  double get subtotal => price * quantity;
}

class CartModel {
  final String id;
  final List<CartItemModel> items;

  CartModel({required this.id, required this.items});

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json['_id'] ?? '',
        items: (json['items'] as List<dynamic>? ?? [])
            .map((i) => CartItemModel.fromJson(i))
            .toList(),
      );

  double get total => items.fold(0, (sum, i) => sum + i.subtotal);
  int get itemCount => items.length;
}
