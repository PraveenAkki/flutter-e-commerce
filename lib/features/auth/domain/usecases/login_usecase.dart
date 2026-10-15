import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import '../validators/login_validator.dart';

class LoginUseCase {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);

  Future<void> call({required String email, required String password}) async {
    // The form already validates, but business rules must not depend on the UI.
    final inputError = LoginValidator.validateEmail(email) ??
        LoginValidator.validatePassword(password);
    if (inputError != null) throw AuthFailure(inputError);

    await _repository.login(email: email.trim(), password: password);
  }
}