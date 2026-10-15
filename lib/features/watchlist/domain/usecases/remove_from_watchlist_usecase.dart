import '../repositories/watchlist_repository.dart';

class RemoveFromWatchlistUseCase {
  final WatchlistRepository _repository;
  const RemoveFromWatchlistUseCase(this._repository);

  Future<void> call(String productId) =>
      _repository.removeFromWatchlist(productId);
}