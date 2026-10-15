import '../../../../core/constants/app_strings.dart';

/// Pure validation rules. Returns an error message, or null when valid.
class LoginValidator {
  const LoginValidator._();

  static const minimumPasswordLength = 6;
  static final _emailPattern = RegExp(r'^[\w.+\-]+@([\w\-]+\.)+[\w\-]{2,}$');

  static String? validateEmail(String email) {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) return AppStrings.emailRequired;
    if (!_emailPattern.hasMatch(trimmedEmail)) return AppStrings.emailInvalid;
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return AppStrings.passwordRequired;
    if (password.length < minimumPasswordLength) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }
}