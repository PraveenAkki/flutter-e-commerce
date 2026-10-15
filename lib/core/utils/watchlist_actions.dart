import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/product/domain/entities/product.dart';
import '../../features/watchlist/presentation/bloc/watchlist_bloc.dart';
import '../../features/watchlist/presentation/bloc/watchlist_event.dart';
import '../constants/app_strings.dart';
import 'app_feedback.dart';
import 'login_gate.dart';

class WatchlistActions {
  const WatchlistActions._();

  static void toggle(BuildContext context, Product product) {
    LoginGate.runIfLoggedIn(context, () {
      final bloc = context.read<WatchlistBloc>();

      if (bloc.state.isInWatchlist(product.id)) {
        bloc.add(RemoveFromWatchlist(product.id));
        AppFeedback.toast(AppStrings.removedFromWatchlist);
      } else {
        bloc.add(AddToWatchlist(product));
        AppFeedback.toast(AppStrings.addedToWatchlist);
      }
    });
  }
}