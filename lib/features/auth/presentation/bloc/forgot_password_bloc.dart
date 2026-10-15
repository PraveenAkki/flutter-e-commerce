import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/submit_status.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ResetPasswordUseCase _resetPassword;

  ForgotPasswordBloc({required ResetPasswordUseCase resetPassword})
      : _resetPassword = resetPassword,
        super(const ForgotPasswordState()) {
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  Future<void> _onResetPasswordSubmitted(
      ResetPasswordSubmitted event,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(const ForgotPasswordState(status: SubmitStatus.submitting));
    try {
      await _resetPassword(email: event.email, newPassword: event.newPassword);
      emit(const ForgotPasswordState(status: SubmitStatus.success));
    } on Failure catch (failure) {
      emit(ForgotPasswordState(
        status: SubmitStatus.failure,
        failureMessage: failure.message,
      ));
    }
  }
}