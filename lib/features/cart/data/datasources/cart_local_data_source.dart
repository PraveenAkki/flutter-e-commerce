import '../../../product/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';

abstract class CartLocalDataSource {
  Future<List<CartItem>> getItems();
  Future<void> addProduct(Product product);
  Future<void> removeProduct(String productId);
  Future<void> setQuantity(String productId, int quantity);
  Future<void> clearItems();
}

/// Keeps the cart in memory. It is lost when the app closes,
/// which is what the assessment asks for (no database).
class CartLocalDataSourceImpl implements CartLocalDataSource {
  final List<CartItem> _items = [];

  @override
  Future<List<CartItem>> getItems() async => List.unmodifiable(_items);

  @override
  Future<void> addProduct(Product product) async {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index == -1) {
      _items.add(CartItem(product: product));
    } else {
      final item = _items[index];
      _items[index] = item.copyWith(quantity: item.quantity + 1);
    }
  }

  @override
  Future<void> removeProduct(String productId) async {
    _items.removeWhere((item) => item.product.id == productId);
  }

  @override
  Future<void> setQuantity(String productId, int quantity) async {
    // A quantity below 1 means the item should not be in the cart.
    if (quantity < 1) {
      await removeProduct(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index == -1) return;
    _items[index] = _items[index].copyWith(quantity: quantity);
  }

  @override
  Future<void> clearItems() async => _items.clear();
}