import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_category.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasource/product_local_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource _dataSource;
  const ProductRepositoryImpl(this._dataSource);

  @override
  Future<List<Product>> getProducts() async {
    final models = await _guard(_dataSource.getProducts);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ProductCategory>> getCategories() async {
    final models = await _guard(_dataSource.getCategories);
    return models.map((m) => m.toEntity()).toList();
  }

  /// Converts data-layer exceptions into domain failures.
  Future<T> _guard<T>(Future<T> Function() readData) async {
    try {
      return await readData();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    } catch (_) {
      throw const UnexpectedFailure();
    }
  }
}