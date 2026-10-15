import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/add_to_watchlist_usecase.dart';
import '../../domain/usecases/clear_watchlist_usecase.dart';
import '../../domain/usecases/get_watchlist_usecase.dart';
import '../../domain/usecases/remove_from_watchlist_usecase.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlistUseCase _getWatchlist;
  final AddToWatchlistUseCase _addToWatchlist;
  final RemoveFromWatchlistUseCase _removeFromWatchlist;
  final ClearWatchlistUseCase _clearWatchlist;

  WatchlistBloc({
    required GetWatchlistUseCase getWatchlist,
    required AddToWatchlistUseCase addToWatchlist,
    required RemoveFromWatchlistUseCase removeFromWatchlist,
    required ClearWatchlistUseCase clearWatchlist,
  })  : _getWatchlist = getWatchlist,
        _addToWatchlist = addToWatchlist,
        _removeFromWatchlist = removeFromWatchlist,
        _clearWatchlist = clearWatchlist,
        super(const WatchlistInitial()) {
    on<LoadWatchlist>(_onLoadWatchlist);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<ClearWatchlist>(_onClearWatchlist);
  }

  Future<void> _onLoadWatchlist(
      LoadWatchlist event,
      Emitter<WatchlistState> emit,
      ) async {
    emit(const WatchlistLoading());
    await _changeThenShowSavedProducts(emit);
  }

  Future<void> _onAddToWatchlist(
      AddToWatchlist event,
      Emitter<WatchlistState> emit,
      ) {
    return _changeThenShowSavedProducts(
      emit,
      change: () => _addToWatchlist(event.product),
    );
  }

  Future<void> _onRemoveFromWatchlist(
      RemoveFromWatchlist event,
      Emitter<WatchlistState> emit,
      ) {
    return _changeThenShowSavedProducts(
      emit,
      change: () => _removeFromWatchlist(event.productId),
    );
  }

  Future<void> _onClearWatchlist(
      ClearWatchlist event,
      Emitter<WatchlistState> emit,
      ) {
    return _changeThenShowSavedProducts(emit, change: _clearWatchlist.call);
  }

  /// Applies the change (if any), then emits the latest saved products.
  /// Reading the list again keeps the state identical to what is stored.
  Future<void> _changeThenShowSavedProducts(
      Emitter<WatchlistState> emit, {
        Future<void> Function()? change,
      }) async {
    try {
      if (change != null) await change();
      final products = await _getWatchlist();
      emit(products.isEmpty ? const WatchlistEmpty() : WatchlistLoaded(products));
    } on Failure catch (failure) {
      emit(WatchlistError(failure.message));
    }
  }
}