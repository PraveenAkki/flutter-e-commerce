import 'package:e_clothing/features/cart/domain/entities/cart_item.dart';
import 'package:e_clothing/features/cart/presentation/bloc/cart_state.dart';
import 'package:e_clothing/features/product/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tee = Product(
    id: 'p1',
    name: 'Tee',
    subtitle: 'Cotton',
    price: 799,
    imageUrl: 'img1',
    category: 'tops',
  );
  const jacket = Product(
    id: 'p2',
    name: 'Jacket',
    subtitle: 'Denim',
    price: 2999,
    imageUrl: 'img2',
    category: 'outerwear',
  );

  group('item subtotal', () {
    test('is price x quantity', () {
      const item = CartItem(product: tee, quantity: 3);

      expect(item.subtotal, 2397);
    });

    test('changes when the quantity changes', () {
      const item = CartItem(product: tee);

      expect(item.copyWith(quantity: 4).subtotal, 3196);
    });
  });

  group('cart total', () {
    test('adds up the subtotal of every item', () {
      const cart = CartLoaded([
        CartItem(product: tee, quantity: 2),
        CartItem(product: jacket),
      ]);

      expect(cart.totalAmount, 4597); // 799 x 2 + 2999
    });

    test('updates when a quantity is increased', () {
      const before = CartLoaded([CartItem(product: tee), CartItem(product: jacket)]);
      const after = CartLoaded([
        CartItem(product: tee, quantity: 2),
        CartItem(product: jacket),
      ]);

      expect(before.totalAmount, 3798);
      expect(after.totalAmount, 4597);
    });

    test('is zero when the cart has no items', () {
      expect(const CartLoaded([]).totalAmount, 0);
    });
  });

  group('item count', () {
    test('adds up every quantity', () {
      const cart = CartLoaded([
        CartItem(product: tee, quantity: 2),
        CartItem(product: jacket),
      ]);

      expect(cart.totalItems, 3);
    });

    test('is zero for an empty cart', () {
      expect(const CartEmpty().totalItems, 0);
    });
  });
}