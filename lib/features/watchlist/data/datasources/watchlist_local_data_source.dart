import '../../../product/domain/entities/product.dart';

abstract class WatchlistLocalDataSource {
  Future<List<Product>> getProducts();
  Future<void> addProduct(Product product);
  Future<void> removeProduct(String productId);
  Future<void> clearProducts();
}

/// Keeps the saved products in memory. They are lost when the app closes,
/// which is what the assessment asks for (no database).
class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  final List<Product> _savedProducts = [];

  @override
  Future<List<Product>> getProducts() async => List.unmodifiable(_savedProducts);

  @override
  Future<void> addProduct(Product product) async {
    final isAlreadySaved = _savedProducts.any((saved) => saved.id == product.id);
    if (!isAlreadySaved) _savedProducts.add(product);
  }

  @override
  Future<void> removeProduct(String productId) async {
    _savedProducts.removeWhere((saved) => saved.id == productId);
  }

  @override
  Future<void> clearProducts() async => _savedProducts.clear();
}