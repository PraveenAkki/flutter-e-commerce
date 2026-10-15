import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/check_session_usecase.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  static const _minimumDisplayTime = Duration(seconds: 2);

  final CheckSessionUseCase _checkSession;

  SplashBloc({required CheckSessionUseCase checkSession})
      : _checkSession = checkSession,
        super(const SplashInitial()) {
    on<SplashStarted>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(
      SplashStarted event,
      Emitter<SplashState> emit,
      ) async {
    // The timer runs while the session check happens, so the logo is
    // always visible for at least two seconds, never longer than needed.
    final minimumDisplay = Future<void>.delayed(_minimumDisplayTime);
    final isLoggedIn = await _checkSession();
    await minimumDisplay;

    emit(isLoggedIn ? const SplashLoggedIn() : const SplashGuest());
  }
}