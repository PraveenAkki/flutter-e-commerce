import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import '../validators/login_validator.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;
  const ResetPasswordUseCase(this._repository);

  Future<void> call({required String email, required String newPassword}) async {
    final inputError = LoginValidator.validateEmail(email) ??
        LoginValidator.validatePassword(newPassword);
    if (inputError != null) throw AuthFailure(inputError);

    await _repository.resetPassword(email: email.trim(), newPassword: newPassword);
  }
}