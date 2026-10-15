import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/failures.dart';
import '../entities/payment_receipt.dart';
import '../repositories/payment_repository.dart';

class ProcessDummyPaymentUseCase {
  final PaymentRepository _repository;
  const ProcessDummyPaymentUseCase(this._repository);

  Future<PaymentReceipt> call(double amount) async {
    if (amount <= 0) throw const PaymentFailure(AppStrings.nothingToPay);

    return _repository.processPayment(amount);
  }
}