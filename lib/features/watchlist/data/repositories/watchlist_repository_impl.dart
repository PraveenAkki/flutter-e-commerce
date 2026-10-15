import '../../../../core/error/failures.dart';
import '../../../product/domain/entities/product.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../datasources/watchlist_local_data_source.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource _dataSource;
  const WatchlistRepositoryImpl(this._dataSource);

  @override
  Future<List<Product>> getWatchlist() => _guard(_dataSource.getProducts);

  @override
  Future<void> addToWatchlist(Product product) =>
      _guard(() => _dataSource.addProduct(product));

  @override
  Future<void> removeFromWatchlist(String productId) =>
      _guard(() => _dataSource.removeProduct(productId));

  @override
  Future<void> clearWatchlist() => _guard(_dataSource.clearProducts);

  /// Turns any data-layer error into a domain failure.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (_) {
      throw const UnexpectedFailure();
    }
  }
}