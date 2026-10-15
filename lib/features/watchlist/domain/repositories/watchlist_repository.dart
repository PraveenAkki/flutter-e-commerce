import '../../../product/domain/entities/product.dart';

abstract class WatchlistRepository {
  Future<List<Product>> getWatchlist();
  Future<void> addToWatchlist(Product product);
  Future<void> removeFromWatchlist(String productId);
  Future<void> clearWatchlist();
}