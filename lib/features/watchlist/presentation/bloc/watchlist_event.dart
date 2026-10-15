import 'package:equatable/equatable.dart';

import '../../../product/domain/entities/product.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();
  @override
  List<Object?> get props => [];
}

class LoadWatchlist extends WatchlistEvent {
  const LoadWatchlist();
}

class AddToWatchlist extends WatchlistEvent {
  final Product product;
  const AddToWatchlist(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveFromWatchlist extends WatchlistEvent {
  final String productId;
  const RemoveFromWatchlist(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Used on logout so the next user does not see this user's saved products.
class ClearWatchlist extends WatchlistEvent {
  const ClearWatchlist();
}