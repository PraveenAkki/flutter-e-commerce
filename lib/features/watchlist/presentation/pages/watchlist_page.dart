import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/state_message_view.dart';

import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';
import '../widgets/product_grid.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.watchlist)),
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) => switch (state) {
          WatchlistInitial() || WatchlistLoading() =>
          const Center(child: CircularProgressIndicator()),
          WatchlistLoaded(:final products) => ProductGrid(products: products),
          WatchlistEmpty() => const StateMessageView(
            icon: Icons.favorite_border,
            message: AppStrings.emptyWatchlist,
          ),
          WatchlistError(:final message) => StateMessageView(
            icon: Icons.error_outline,
            message: message,
            actionLabel: AppStrings.retry,
            onAction: () =>
                context.read<WatchlistBloc>().add(const LoadWatchlist()),
          ),
        },
      ),
    );
  }
}