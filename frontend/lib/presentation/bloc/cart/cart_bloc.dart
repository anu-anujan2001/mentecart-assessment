import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc(this.repository) : super(CartInitial()) {
    on<LoadCartEvent>(_onLoad);
    on<AddToCartEvent>(_onAdd);
    on<UpdateCartItemEvent>(_onUpdate);
    on<RemoveCartItemEvent>(_onRemove);
  }

  Future<void> _onLoad(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cart = await repository.getCart();
      if (cart != null) {
        emit(CartLoaded(cart));
      } else {
        emit(CartError('Cart not found'));
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAdd(AddToCartEvent event, Emitter<CartState> emit) async {
    try {
      final cart = await repository.addItem(
        serviceId: event.serviceId,
        date: event.date,
        startTime: event.startTime,
        quantity: event.quantity,
      );
      emit(CartOperationSuccess(cart, message: 'Added to cart!'));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onUpdate(
      UpdateCartItemEvent event, Emitter<CartState> emit) async {
    try {
      final cart =
          await repository.updateItem(event.itemId, quantity: event.quantity);
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemove(
      RemoveCartItemEvent event, Emitter<CartState> emit) async {
    try {
      final cart = await repository.removeItem(event.itemId);
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
