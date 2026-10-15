import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cart/presentation/widgets/cart_icon_button.dart';
import '../../../../config/di/injection_container.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/login_gate.dart';
import '../../../../core/widgets/state_message_view.dart';
import '../../../auth/presentation/widgets/session_action_button.dart';
import '../../../watchlist/presentation/pages/watchlist_page.dart';
import '../../../watchlist/presentation/widgets/product_grid.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import 'category_strip.dart';


class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  void _openWatchlist(BuildContext context) {
    LoginGate.runIfLoggedIn(
      context,
          () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const WatchlistPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductBloc>()..add(const LoadProducts()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.products),
          actions: [
            IconButton(
              tooltip: AppStrings.watchlist,
              icon: const Icon(Icons.favorite_border),
              onPressed: () => _openWatchlist(context),
            ),
            const CartIconButton(),
            const SessionActionButton(),
          ],
        ),
        body: const _ProductListBody(),
      ),
    );
  }
}

class _ProductListBody extends StatelessWidget {
  const _ProductListBody();

  @override
  Widget build(BuildContext context) {
    void reload() => context.read<ProductBloc>().add(const LoadProducts());

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) => switch (state) {
        ProductInitial() || ProductLoading() =>
        const Center(child: CircularProgressIndicator()),
        ProductLoaded() => _LoadedView(state: state),
        ProductEmpty() => StateMessageView(
          icon: Icons.checkroom_outlined,
          message: AppStrings.noProducts,
          actionLabel: AppStrings.retry,
          onAction: reload,
        ),
        ProductError(:final message) => StateMessageView(
          icon: Icons.error_outline,
          message: message,
          actionLabel: AppStrings.retry,
          onAction: reload,
        ),
      },
    );
  }
}

class _LoadedView extends StatelessWidget {
  final ProductLoaded state;
  const _LoadedView({required this.state});

  @override
  Widget build(BuildContext context) {
    final products = state.visibleProducts;

    return Column(
      children: [
        CategoryStrip(
          categories: state.categories,
          selectedCategoryId: state.selectedCategoryId,
          onSelected: (id) =>
              context.read<ProductBloc>().add(CategorySelected(id)),
        ),
        Expanded(
          child: products.isEmpty
              ? const StateMessageView(
            icon: Icons.checkroom_outlined,
            message: AppStrings.noProductsInCategory,
          )
              : ProductGrid(products: products),
        ),
      ],
    );
  }
}