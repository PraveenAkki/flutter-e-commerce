import '../entities/payment_receipt.dart';

abstract class PaymentRepository {
  Future<PaymentReceipt> processPayment(double amount);
}