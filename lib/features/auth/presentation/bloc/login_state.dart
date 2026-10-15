import 'package:equatable/equatable.dart';

import '../../domain/validators/login_validator.dart';

enum LoginStatus { editing, submitting, success, failure }

class LoginState extends Equatable {
  final String email;
  final String password;
  final LoginStatus status;
  final String? failureMessage;

  const LoginState({
    this.email = '',
    this.password = '',
    this.status = LoginStatus.editing,
    this.failureMessage,
  });

  // Errors appear only after the user has typed something.
  String? get emailError =>
      email.isEmpty ? null : LoginValidator.validateEmail(email);

  String? get passwordError =>
      password.isEmpty ? null : LoginValidator.validatePassword(password);

  bool get isSubmitting => status == LoginStatus.submitting;

  bool get canSubmit =>
      !isSubmitting &&
          LoginValidator.validateEmail(email) == null &&
          LoginValidator.validatePassword(password) == null;

  /// [failureMessage] is deliberately not carried over: every new state
  /// starts without an error unless one is passed in.
  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    String? failureMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      failureMessage: failureMessage,
    );
  }

  @override
  List<Object?> get props => [email, password, status, failureMessage];
}