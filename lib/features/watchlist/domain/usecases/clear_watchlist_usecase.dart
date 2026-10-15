import '../repositories/watchlist_repository.dart';

class ClearWatchlistUseCase {
  final WatchlistRepository _repository;
  const ClearWatchlistUseCase(this._repository);

  Future<void> call() => _repository.clearWatchlist();
}