import 'package:equatable/equatable.dart';

import '../../domain/entities/cart_item.dart';

sealed class CartState extends Equatable {
  const CartState();

  /// Number shown on the cart badge. Only a loaded cart has items.
  int get totalItems => 0;

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final List<CartItem> items;
  const CartLoaded(this.items);

  @override
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => items.fold(0, (sum, item) => sum + item.subtotal);

  @override
  List<Object?> get props => [items];
}

class CartEmpty extends CartState {
  const CartEmpty();
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}