import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../payment/presentation/pages/checkout_page.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/state_message_view.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_item_tile.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.cart),
        actions: [
          IconButton(
            tooltip: AppStrings.clearCart,
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () => context.read<CartBloc>().add(const ClearCart()),
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) => switch (state) {
          CartInitial() || CartLoading() =>
          const Center(child: CircularProgressIndicator()),
          CartLoaded() => _CartContent(state: state),
          CartEmpty() => const StateMessageView(
            icon: Icons.shopping_bag_outlined,
            message: AppStrings.emptyCart,
          ),
          CartError(:final message) => StateMessageView(
            icon: Icons.error_outline,
            message: message,
            actionLabel: AppStrings.retry,
            onAction: () => context.read<CartBloc>().add(const LoadCart()),
          ),
        },
      ),
    );
  }
}

class _CartContent extends StatelessWidget {
  final CartLoaded state;
  const _CartContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CartBloc>();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              final productId = item.product.id;

              return CartItemTile(
                item: item,
                onIncrease: () => bloc.add(IncreaseQuantity(productId)),
                onDecrease: () => bloc.add(DecreaseQuantity(productId)),
                onRemove: () => bloc.add(RemoveFromCart(productId)),
              );
            },
          ),
        ),
        _CheckoutBar(state: state),
      ],
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  final CartLoaded state;
  const _CheckoutBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      elevation: 8,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${AppStrings.total} (${state.totalItems} ${AppStrings.itemsLabel})',
                      style: textTheme.titleMedium),
                  Text(
                    CurrencyFormatter.format(state.totalAmount),
                    style: textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  // Replaced by the payment screen in Step 5.
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CheckoutPage()),
                  ),
                  child: const Text(AppStrings.checkout),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}