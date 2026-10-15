import 'package:equatable/equatable.dart';

sealed class SessionState extends Equatable {
  const SessionState();
  @override
  List<Object?> get props => [];
}

class SessionUnknown extends SessionState {
  const SessionUnknown();
}

class SessionAuthenticated extends SessionState {
  const SessionAuthenticated();
}

class SessionGuest extends SessionState {
  const SessionGuest();
}