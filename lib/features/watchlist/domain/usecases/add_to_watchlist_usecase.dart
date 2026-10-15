import '../../../product/domain/entities/product.dart';
import '../repositories/watchlist_repository.dart';

class AddToWatchlistUseCase {
  final WatchlistRepository _repository;
  const AddToWatchlistUseCase(this._repository);

  Future<void> call(Product product) => _repository.addToWatchlist(product);
}