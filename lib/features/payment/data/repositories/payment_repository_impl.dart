import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/payment_receipt.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_local_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentLocalDataSource _dataSource;
  const PaymentRepositoryImpl(this._dataSource);

  @override
  Future<PaymentReceipt> processPayment(double amount) async {
    try {
      final orderId = await _dataSource.makePayment(amount);
      return PaymentReceipt(orderId: orderId, amountPaid: amount);
    } catch (_) {
      throw const PaymentFailure(AppStrings.paymentFailed);
    }
  }
}