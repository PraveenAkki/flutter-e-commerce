import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/di/injection_container.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/loading_button.dart';
import '../../../../core/widgets/state_message_view.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';
import 'payment_success_page.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  void _onPaymentStateChanged(BuildContext context, PaymentState state) {
    if (state is PaymentSuccess) {
      // The receipt already holds the paid amount, so clearing the cart is safe.
      context.read<CartBloc>().add(const ClearCart());
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => PaymentSuccessPage(receipt: state.receipt),
        ),
            (route) => route.isFirst,
      );
    } else if (state is PaymentFailed) {
      AppFeedback.error(context, state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PaymentBloc>(),
      child: BlocConsumer<PaymentBloc, PaymentState>(
        listener: _onPaymentStateChanged,
        builder: (context, paymentState) {
          final isProcessing = paymentState is PaymentProcessing;

          return PopScope(
            // The user cannot leave while the payment is being processed.
            canPop: !isProcessing,
            child: Scaffold(
              appBar: AppBar(title: const Text(AppStrings.checkoutTitle)),
              body: BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  if (cartState is! CartLoaded) {
                    return const StateMessageView(
                      icon: Icons.shopping_bag_outlined,
                      message: AppStrings.emptyCart,
                    );
                  }
                  return _CheckoutContent(
                    cart: cartState,
                    isProcessing: isProcessing,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CheckoutContent extends StatelessWidget {
  final CartLoaded cart;
  final bool isProcessing;

  const _CheckoutContent({required this.cart, required this.isProcessing});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(AppStrings.orderSummary, style: textTheme.titleLarge),
              const SizedBox(height: 12),
              for (final item in cart.items)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.product.name} x ${item.quantity}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(CurrencyFormatter.format(item.subtotal)),
                    ],
                  ),
                ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppStrings.totalPayable, style: textTheme.titleMedium),
                  Text(
                    CurrencyFormatter.format(cart.totalAmount),
                    style: textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LoadingButton(
              label: AppStrings.payNow,
              isLoading: isProcessing,
              onPressed: () => context
                  .read<PaymentBloc>()
                  .add(InitiatePayment(cart.totalAmount)),
            ),
          ),
        ),
      ],
    );
  }
}