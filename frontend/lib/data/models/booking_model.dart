import 'service_model.dart';

class BookingItemModel {
  final String? id;
  final ServiceModel? service;
  final int quantity;
  final String date;
  final String startTime;
  final double price;

  BookingItemModel({
    this.id,
    this.service,
    required this.quantity,
    required this.date,
    required this.startTime,
    required this.price,
  });

  factory BookingItemModel.fromJson(Map<String, dynamic> json) =>
      BookingItemModel(
        id: json['_id'],
        service: json['service'] is Map<String, dynamic>
            ? ServiceModel.fromJson(json['service'])
            : null,
        quantity: json['quantity'] ?? 1,
        date: json['date'] ?? '',
        startTime: json['startTime'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
      );
}

class BookingModel {
  final String id;
  final List<BookingItemModel> items;
  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String status;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        id: json['_id'] ?? '',
        items: (json['items'] as List<dynamic>? ?? [])
            .map((i) => BookingItemModel.fromJson(i))
            .toList(),
        totalAmount: (json['totalAmount'] ?? 0).toDouble(),
        paymentMethod: json['paymentMethod'] ?? 'cash',
        paymentStatus: json['paymentStatus'] ?? 'pending',
        status: json['status'] ?? 'pending',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
      );

  bool get canCancel =>
      status != 'cancelled' && status != 'completed' && status != 'failed';
}
