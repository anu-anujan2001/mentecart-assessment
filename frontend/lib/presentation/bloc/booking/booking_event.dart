import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

class LoadBookingsEvent extends BookingEvent {}

class LoadBookingDetailEvent extends BookingEvent {
  final String id;
  const LoadBookingDetailEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class CheckoutEvent extends BookingEvent {
  final String paymentMethod;
  const CheckoutEvent(this.paymentMethod);
  @override
  List<Object?> get props => [paymentMethod];
}

class CancelBookingEvent extends BookingEvent {
  final String id;
  const CancelBookingEvent(this.id);
  @override
  List<Object?> get props => [id];
}
