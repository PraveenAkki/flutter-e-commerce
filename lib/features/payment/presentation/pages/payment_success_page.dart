import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/payment_receipt.dart';

class PaymentSuccessPage extends StatelessWidget {
  final PaymentReceipt receipt;
  const PaymentSuccessPage({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, size: 88, color: Colors.green),
                const SizedBox(height: 16),
                Text(AppStrings.paymentSuccessful,
                    style: textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 28),
                _ReceiptRow(label: AppStrings.orderIdLabel, value: receipt.orderId),
                const SizedBox(height: 8),
                _ReceiptRow(
                  label: AppStrings.amountPaidLabel,
                  value: CurrencyFormatter.format(receipt.amountPaid),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    // The product list is the first route, so go back to it.
                    onPressed: () =>
                        Navigator.of(context).popUntil((route) => route.isFirst),
                    child: const Text(AppStrings.continueShopping),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  const _ReceiptRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Flexible(
          child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}