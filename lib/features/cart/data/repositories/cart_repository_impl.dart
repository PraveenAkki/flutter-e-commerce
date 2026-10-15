import '../../../../core/error/failures.dart';
import '../../../product/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _dataSource;
  const CartRepositoryImpl(this._dataSource);

  @override
  Future<List<CartItem>> getCart() => _guard(_dataSource.getItems);

  @override
  Future<void> addToCart(Product product) =>
      _guard(() => _dataSource.addProduct(product));

  @override
  Future<void> removeFromCart(String productId) =>
      _guard(() => _dataSource.removeProduct(productId));

  @override
  Future<void> updateQuantity(String productId, int quantity) =>
      _guard(() => _dataSource.setQuantity(productId, quantity));

  @override
  Future<void> clearCart() => _guard(_dataSource.clearItems);

  /// Turns any data-layer error into a domain failure.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (_) {
      throw const UnexpectedFailure();
    }
  }
}