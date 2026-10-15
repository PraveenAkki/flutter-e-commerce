class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Unable to read local data']);
}

class InvalidCredentialsException implements Exception {
  final String message;
  const InvalidCredentialsException([this.message = 'Invalid email or password']);
}

class EmailAlreadyUsedException implements Exception {
  final String message;
  const EmailAlreadyUsedException([this.message = 'An account with this email already exists']);
}

class AccountNotFoundException implements Exception {
  final String message;
  const AccountNotFoundException([this.message = 'No registered account found for this email']);
}