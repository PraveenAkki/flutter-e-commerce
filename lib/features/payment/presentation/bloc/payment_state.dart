import 'package:equatable/equatable.dart';

import '../../domain/entities/payment_receipt.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();
  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentProcessing extends PaymentState {
  const PaymentProcessing();
}

class PaymentSuccess extends PaymentState {
  final PaymentReceipt receipt;
  const PaymentSuccess(this.receipt);

  @override
  List<Object?> get props => [receipt];
}

class PaymentFailed extends PaymentState {
  final String message;
  const PaymentFailed(this.message);

  @override
  List<Object?> get props => [message];
}