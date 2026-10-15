import 'package:e_clothing/core/constants/app_strings.dart';
import 'package:e_clothing/features/auth/domain/validators/login_validator.dart';
import 'package:e_clothing/features/auth/presentation/bloc/login_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('email validation', () {
    test('accepts a correctly formatted email', () {
      expect(LoginValidator.validateEmail('test@eclothing.com'), isNull);
    });

    test('ignores spaces around the email', () {
      expect(LoginValidator.validateEmail('  test@eclothing.com '), isNull);
    });

    test('rejects an empty email', () {
      expect(LoginValidator.validateEmail(''), AppStrings.emailRequired);
    });

    test('rejects an email without @', () {
      expect(LoginValidator.validateEmail('eclothing.com'), AppStrings.emailInvalid);
    });

    test('rejects an email without a domain extension', () {
      expect(LoginValidator.validateEmail('user@eclothing'), AppStrings.emailInvalid);
    });
  });

  group('password validation', () {
    test('accepts a password of the minimum length', () {
      expect(LoginValidator.validatePassword('123456'), isNull);
    });

    test('rejects an empty password', () {
      expect(LoginValidator.validatePassword(''), AppStrings.passwordRequired);
    });

    test('rejects a password shorter than 6 characters', () {
      expect(LoginValidator.validatePassword('12345'), AppStrings.passwordTooShort);
    });
  });

  group('login button', () {
    test('is disabled while the form is empty', () {
      expect(const LoginState().canSubmit, isFalse);
    });

    test('is disabled for an invalid email', () {
      const state = LoginState(email: 'abc', password: 'Test@123');

      expect(state.emailError, AppStrings.emailInvalid);
      expect(state.canSubmit, isFalse);
    });

    test('is disabled for a short password', () {
      const state = LoginState(email: 'test@eclothing.com', password: '123');

      expect(state.passwordError, AppStrings.passwordTooShort);
      expect(state.canSubmit, isFalse);
    });

    test('is enabled when both fields are valid', () {
      const state = LoginState(email: 'test@eclothing.com', password: 'Test@123');

      expect(state.canSubmit, isTrue);
    });

    test('is disabled while the login request is running', () {
      const state = LoginState(
        email: 'test@eclothing.com',
        password: 'Test@123',
        status: LoginStatus.submitting,
      );

      expect(state.canSubmit, isFalse);
    });
  });
}