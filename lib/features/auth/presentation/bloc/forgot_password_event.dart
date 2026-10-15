import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
  @override
  List<Object?> get props => [];
}

class ResetPasswordSubmitted extends ForgotPasswordEvent {
  final String email;
  final String newPassword;

  const ResetPasswordSubmitted({required this.email, required this.newPassword});

  @override
  List<Object?> get props => [email, newPassword];
}