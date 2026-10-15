import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _login;

  LoginBloc({required LoginUseCase login})
      : _login = login,
        super(const LoginState()) {
    on<LoginEmailChanged>(
          (event, emit) => emit(
        state.copyWith(email: event.email, status: LoginStatus.editing),
      ),
    );
    on<LoginPasswordChanged>(
          (event, emit) => emit(
        state.copyWith(password: event.password, status: LoginStatus.editing),
      ),
    );
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event,
      Emitter<LoginState> emit,
      ) async {
    if (!state.canSubmit) return;

    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _login(email: state.email, password: state.password);
      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch (failure) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        failureMessage: failure.message,
      ));
    }
  }
}