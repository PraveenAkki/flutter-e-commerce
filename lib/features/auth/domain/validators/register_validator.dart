import '../../../../core/constants/app_strings.dart';

/// Extra rules for the register and reset forms.
/// Email and password rules are reused from LoginValidator.
class RegisterValidator {
  const RegisterValidator._();

  static String? validateName(String name) {
    if (name.trim().isEmpty) return AppStrings.nameRequired;
    return null;
  }

  static String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) return AppStrings.confirmPasswordRequired;
    if (password != confirmPassword) return AppStrings.passwordsDoNotMatch;
    return null;
  }
}