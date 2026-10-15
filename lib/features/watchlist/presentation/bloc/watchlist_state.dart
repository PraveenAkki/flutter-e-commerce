import 'package:equatable/equatable.dart';

import '../../../product/domain/entities/product.dart';

sealed class WatchlistState extends Equatable {
  const WatchlistState();


  bool isInWatchlist(String productId) => false;

  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {
  const WatchlistInitial();
}

class WatchlistLoading extends WatchlistState {
  const WatchlistLoading();
}

class WatchlistLoaded extends WatchlistState {
  final List<Product> products;
  const WatchlistLoaded(this.products);

  @override
  bool isInWatchlist(String productId) =>
      products.any((product) => product.id == productId);

  @override
  List<Object?> get props => [products];
}

class WatchlistEmpty extends WatchlistState {
  const WatchlistEmpty();
}

class WatchlistError extends WatchlistState {
  final String message;
  const WatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}