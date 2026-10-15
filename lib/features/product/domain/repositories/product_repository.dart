import '../entities/product.dart';
import '../entities/product_category.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<List<ProductCategory>> getCategories();
}