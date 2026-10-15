import 'package:equatable/equatable.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();
  @override
  List<Object?> get props => [];
}

/// Read the saved token when the app starts.
class SessionChecked extends SessionEvent {
  const SessionChecked();
}

class UserLoggedIn extends SessionEvent {
  const UserLoggedIn();
}

class LogoutRequested extends SessionEvent {
  const LogoutRequested();
}