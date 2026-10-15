import '../../../product/domain/entities/product.dart';
import '../repositories/watchlist_repository.dart';

class GetWatchlistUseCase {
  final WatchlistRepository _repository;
  const GetWatchlistUseCase(this._repository);

  Future<List<Product>> call() => _repository.getWatchlist();
}