import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/constants/test_credentials.dart';
import '../../../../core/error/exceptions.dart';

abstract class AuthLocalDataSource {
  /// Each method returns or completes normally on success
  /// and throws an exception from core/error/exceptions.dart on failure.
  Future<String> login({required String email, required String password});
  Future<String> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> resetPassword({required String email, required String newPassword});
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _nameKey = 'registered_name';
  static const _emailKey = 'registered_email';
  static const _passwordKey = 'registered_password';

  final FlutterSecureStorage _storage;
  const AuthLocalDataSourceImpl(this._storage);

  @override
  Future<String> login({required String email, required String password}) async {
    // Simulates a network call so the loading state is visible.
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final enteredEmail = email.toLowerCase();

    final isTestUser = enteredEmail == TestCredentials.email &&
        password == TestCredentials.password;
    if (isTestUser) return _createToken();

    final savedEmail = await _storage.read(key: _emailKey);
    final savedPassword = await _storage.read(key: _passwordKey);
    final isRegisteredUser =
        enteredEmail == savedEmail && password == savedPassword;
    if (isRegisteredUser) return _createToken();

    throw const InvalidCredentialsException();
  }

  @override
  Future<String> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final enteredEmail = email.toLowerCase();
    final savedEmail = await _storage.read(key: _emailKey);
    if (enteredEmail == TestCredentials.email || enteredEmail == savedEmail) {
      throw const EmailAlreadyUsedException();
    }

    await _storage.write(key: _nameKey, value: name);
    await _storage.write(key: _emailKey, value: enteredEmail);
    await _storage.write(key: _passwordKey, value: password);
    return _createToken();
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final savedEmail = await _storage.read(key: _emailKey);
    if (savedEmail == null || email.toLowerCase() != savedEmail) {
      throw const AccountNotFoundException();
    }

    await _storage.write(key: _passwordKey, value: newPassword);
  }

  String _createToken() => 'dummy-token-${DateTime.now().millisecondsSinceEpoch}';
}