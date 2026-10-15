import 'package:equatable/equatable.dart';


class PaymentReceipt extends Equatable {
  final String orderId;
  final double amountPaid;

  const PaymentReceipt({required this.orderId, required this.amountPaid});

  @override
  List<Object?> get props => [orderId, amountPaid];
}