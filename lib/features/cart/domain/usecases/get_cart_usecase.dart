import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase {
  final CartRepository _repository;
  const GetCartUseCase(this._repository);

  Future<List<CartItem>> call() => _repository.getCart();
}