import '../repositories/cart_repository.dart';

class UpdateCartQuantityUseCase {
  final CartRepository _repository;
  const UpdateCartQuantityUseCase(this._repository);

  Future<void> call(String productId, int quantity) =>
      _repository.updateQuantity(productId, quantity);
}