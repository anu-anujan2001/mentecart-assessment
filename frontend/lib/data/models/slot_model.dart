class SlotModel {
  final String date;
  final String startTime;
  final String endTime;
  final int remainingCapacity;

  SlotModel({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.remainingCapacity,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) => SlotModel(
        date: json['date'] ?? '',
        startTime: json['startTime'] ?? '',
        endTime: json['endTime'] ?? '',
        remainingCapacity: json['remainingCapacity'] ?? 0,
      );

  bool get isAvailable => remainingCapacity > 0;

  String get displayTime => '$startTime – $endTime';
}
