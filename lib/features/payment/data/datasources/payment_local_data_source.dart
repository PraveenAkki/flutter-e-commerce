abstract class PaymentLocalDataSource {

  Future<String> makePayment(double amount);
}


class PaymentLocalDataSourceImpl implements PaymentLocalDataSource {
  @override
  Future<String> makePayment(double amount) async {
    // Simulates payment processing so the loading state is visible.
    await Future<void>.delayed(const Duration(seconds: 2));

    return 'ORD${DateTime.now().millisecondsSinceEpoch}';
  }
}