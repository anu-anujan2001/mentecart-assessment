import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/booking_repository.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository repository;

  BookingBloc(this.repository) : super(BookingInitial()) {
    on<LoadBookingsEvent>(_onLoad);
    on<LoadBookingDetailEvent>(_onDetail);
    on<CheckoutEvent>(_onCheckout);
    on<CancelBookingEvent>(_onCancel);
  }

  Future<void> _onLoad(
      LoadBookingsEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookings = await repository.getBookings();
      emit(BookingsLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onDetail(
      LoadBookingDetailEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final booking = await repository.getBookingById(event.id);
      emit(BookingDetailLoaded(booking));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onCheckout(
      CheckoutEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final booking = await repository.checkout(event.paymentMethod);
      emit(BookingSuccess(booking));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onCancel(
      CancelBookingEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final booking = await repository.cancelBooking(event.id);
      emit(BookingDetailLoaded(booking));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
