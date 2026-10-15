import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/session_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _authDataSource;
  final SessionLocalDataSource _sessionDataSource;

  const AuthRepositoryImpl(this._authDataSource, this._sessionDataSource);

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      final token = await _authDataSource.login(email: email, password: password);
      await _sessionDataSource.saveToken(token);
    } on InvalidCredentialsException catch (e) {
      throw AuthFailure(e.message);
    } catch (_) {
      throw const UnexpectedFailure();
    }
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // A new account is logged in straight away.
      final token = await _authDataSource.register(
        name: name,
        email: email,
        password: password,
      );
      await _sessionDataSource.saveToken(token);
    } on EmailAlreadyUsedException catch (e) {
      throw AuthFailure(e.message);
    } catch (_) {
      throw const UnexpectedFailure();
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await _authDataSource.resetPassword(email: email, newPassword: newPassword);
    } on AccountNotFoundException catch (e) {
      throw AuthFailure(e.message);
    } catch (_) {
      throw const UnexpectedFailure();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _sessionDataSource.deleteToken();
    } catch (_) {
      throw const UnexpectedFailure();
    }
  }
}