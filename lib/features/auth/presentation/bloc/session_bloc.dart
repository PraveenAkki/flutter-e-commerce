import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/check_session_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'session_event.dart';
import 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final CheckSessionUseCase _checkSession;
  final LogoutUseCase _logout;

  SessionBloc({
    required CheckSessionUseCase checkSession,
    required LogoutUseCase logout,
  })  : _checkSession = checkSession,
        _logout = logout,
        super(const SessionUnknown()) {
    on<SessionChecked>(_onSessionChecked);
    on<UserLoggedIn>((event, emit) => emit(const SessionAuthenticated()));
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onSessionChecked(
      SessionChecked event,
      Emitter<SessionState> emit,
      ) async {
    final isLoggedIn = await _checkSession();
    emit(isLoggedIn ? const SessionAuthenticated() : const SessionGuest());
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<SessionState> emit,
      ) async {
    try {
      await _logout();
    } on Failure {
      // The user asked to log out, so the in-memory session ends either way.
    }
    emit(const SessionGuest());
  }
}