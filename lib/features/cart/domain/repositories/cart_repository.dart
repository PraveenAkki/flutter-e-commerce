import '../../../product/domain/entities/product.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCart();
  Future<void> addToCart(Product product);
  Future<void> removeFromCart(String productId);
  Future<void> updateQuantity(String productId, int quantity);
  Future<void> clearCart();
}