import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final String serviceId;
  final String date;
  final String startTime;
  final int quantity;

  const AddToCartEvent({
    required this.serviceId,
    required this.date,
    required this.startTime,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [serviceId, date, startTime, quantity];
}

class UpdateCartItemEvent extends CartEvent {
  final String itemId;
  final int quantity;
  const UpdateCartItemEvent({required this.itemId, required this.quantity});
  @override
  List<Object?> get props => [itemId, quantity];
}

class RemoveCartItemEvent extends CartEvent {
  final String itemId;
  const RemoveCartItemEvent(this.itemId);
  @override
  List<Object?> get props => [itemId];
}
