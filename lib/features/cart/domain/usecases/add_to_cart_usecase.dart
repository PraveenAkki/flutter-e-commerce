import '../../../product/domain/entities/product.dart';
import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository _repository;
  const AddToCartUseCase(this._repository);

  Future<void> call(Product product) => _repository.addToCart(product);
}