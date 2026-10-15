import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/process_dummy_payment_usecase.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final ProcessDummyPaymentUseCase _processPayment;

  PaymentBloc({required ProcessDummyPaymentUseCase processPayment})
      : _processPayment = processPayment,
        super(const PaymentInitial()) {
    on<InitiatePayment>(_onInitiatePayment);
  }

  Future<void> _onInitiatePayment(
      InitiatePayment event,
      Emitter<PaymentState> emit,
      ) async {
    // A second tap while processing must not start a second payment.
    if (state is PaymentProcessing) return;

    emit(const PaymentProcessing());
    try {
      final receipt = await _processPayment(event.amount);
      emit(PaymentSuccess(receipt));
    } on Failure catch (failure) {
      emit(PaymentFailed(failure.message));
    }
  }
}