import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
  @override
  List<Object?> get props => [];
}

class InitiatePayment extends PaymentEvent {
  final double amount;
  const InitiatePayment(this.amount);

  @override
  List<Object?> get props => [amount];
}