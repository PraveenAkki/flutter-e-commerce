import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/submit_status.dart';
import '../../domain/usecases/register_usecase.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _register;

  RegisterBloc({required RegisterUseCase register})
      : _register = register,
        super(const RegisterState()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
      RegisterSubmitted event,
      Emitter<RegisterState> emit,
      ) async {
    emit(const RegisterState(status: SubmitStatus.submitting));
    try {
      await _register(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      emit(const RegisterState(status: SubmitStatus.success));
    } on Failure catch (failure) {
      emit(RegisterState(
        status: SubmitStatus.failure,
        failureMessage: failure.message,
      ));
    }
  }
}