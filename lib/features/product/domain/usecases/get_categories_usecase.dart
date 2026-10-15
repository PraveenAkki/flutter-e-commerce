import '../entities/product_category.dart';
import '../repositories/product_repository.dart';

class GetCategoriesUseCase {
  final ProductRepository _repository;
  const GetCategoriesUseCase(this._repository);

  Future<List<ProductCategory>> call() => _repository.getCategories();
}