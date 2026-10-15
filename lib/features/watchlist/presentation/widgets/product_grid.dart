import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/cart_actions.dart';
import '../../../../core/utils/watchlist_actions.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/presentation/page/product_detail_page.dart';
import '../../../product/presentation/widgets/product_card.dart';
import '../../../watchlist/presentation/bloc/watchlist_bloc.dart';
import '../../../watchlist/presentation/bloc/watchlist_state.dart';


class ProductGrid extends StatelessWidget {
  final List<Product> products;
  const ProductGrid({super.key, required this.products});

  void _openDetails(BuildContext context, Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 900 ? 4 : width >= 600 ? 3 : 2;

    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, watchlistState) => GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.62,
        ),
        itemBuilder: (context, index) {
          final product = products[index];

          return ProductCard(
            product: product,
            isFavourite: watchlistState.isInWatchlist(product.id),
            onTap: () => _openDetails(context, product),
            onFavouriteTap: () => WatchlistActions.toggle(context, product),
            onAddToCart: () => CartActions.addProduct(context, product),
          );
        },
      ),
    );
  }
}