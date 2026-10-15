import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_cart_quantity_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase _getCart;
  final AddToCartUseCase _addToCart;
  final RemoveFromCartUseCase _removeFromCart;
  final UpdateCartQuantityUseCase _updateQuantity;
  final ClearCartUseCase _clearCart;

  CartBloc({
    required GetCartUseCase getCart,
    required AddToCartUseCase addToCart,
    required RemoveFromCartUseCase removeFromCart,
    required UpdateCartQuantityUseCase updateQuantity,
    required ClearCartUseCase clearCart,
  })  : _getCart = getCart,
        _addToCart = addToCart,
        _removeFromCart = removeFromCart,
        _updateQuantity = updateQuantity,
        _clearCart = clearCart,
        super(const CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<IncreaseQuantity>(_onIncreaseQuantity);
    on<DecreaseQuantity>(_onDecreaseQuantity);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    await _showCart(emit);
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    await _showCart(emit, change: () => _addToCart(event.product));
  }

  Future<void> _onRemoveFromCart(
      RemoveFromCart event,
      Emitter<CartState> emit,
      ) async {
    await _showCart(emit, change: () => _removeFromCart(event.productId));
  }

  Future<void> _onIncreaseQuantity(
      IncreaseQuantity event,
      Emitter<CartState> emit,
      ) async {
    final item = _findItem(event.productId);
    if (item == null) return;

    await _showCart(
      emit,
      change: () => _updateQuantity(event.productId, item.quantity + 1),
    );
  }

  Future<void> _onDecreaseQuantity(
      DecreaseQuantity event,
      Emitter<CartState> emit,
      ) async {
    final item = _findItem(event.productId);
    // The lowest quantity is 1. The delete button removes an item.
    if (item == null || item.quantity <= 1) return;

    await _showCart(
      emit,
      change: () => _updateQuantity(event.productId, item.quantity - 1),
    );
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    await _showCart(emit, change: _clearCart.call);
  }

  CartItem? _findItem(String productId) {
    final current = state;
    if (current is! CartLoaded) return null;

    return current.items
        .where((item) => item.product.id == productId)
        .firstOrNull;
  }

  /// Applies the change (if any), then emits the latest cart.
  /// Reading the cart again keeps the state identical to what is stored.
  Future<void> _showCart(
      Emitter<CartState> emit, {
        Future<void> Function()? change,
      }) async {
    try {
      if (change != null) await change();
      final items = await _getCart();
      emit(items.isEmpty ? const CartEmpty() : CartLoaded(items));
    } on Failure catch (failure) {
      emit(CartError(failure.message));
    }
  }
}