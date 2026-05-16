import 'package:equatable/equatable.dart';
import '../../../data/models/cart_model.dart';

abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartModel cart;
  const CartLoaded(this.cart);
  @override
  List<Object?> get props => [cart];
}

class CartOperationSuccess extends CartState {
  final CartModel cart;
  final String? message;
  const CartOperationSuccess(this.cart, {this.message});
  @override
  List<Object?> get props => [cart, message];
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);
  @override
  List<Object?> get props => [message];
}
