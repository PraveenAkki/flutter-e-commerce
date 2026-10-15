import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import '../validators/login_validator.dart';
import '../validators/register_validator.dart';

class RegisterUseCase {
  final AuthRepository _repository;
  const RegisterUseCase(this._repository);

  Future<void> call({
    required String name,
    required String email,
    required String password,
  }) async {
    final inputError = RegisterValidator.validateName(name) ??
        LoginValidator.validateEmail(email) ??
        LoginValidator.validatePassword(password);
    if (inputError != null) throw AuthFailure(inputError);

    await _repository.register(
      name: name.trim(),
      email: email.trim(),
      password: password,
    );
  }
}