import 'slot_model.dart';

class ServiceModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final int duration;
  final String category;
  final String image;
  final int capacityPerSlot;
  final List<SlotModel> slots;

  ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.category,
    required this.image,
    required this.capacityPerSlot,
    required this.slots,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        duration: json['duration'] ?? 60,
        category: json['category'] ?? '',
        image: json['image'] ?? '',
        capacityPerSlot: json['capacityPerSlot'] ?? 1,
        slots: (json['slots'] as List<dynamic>? ?? [])
            .map((s) => SlotModel.fromJson(s))
            .toList(),
      );

  /// Unique dates that have at least one available slot
  List<String> get availableDates {
    final seen = <String>{};
    return slots
        .where((s) => s.isAvailable && seen.add(s.date))
        .map((s) => s.date)
        .toList();
  }

  List<SlotModel> slotsForDate(String date) =>
      slots.where((s) => s.date == date).toList();
}
