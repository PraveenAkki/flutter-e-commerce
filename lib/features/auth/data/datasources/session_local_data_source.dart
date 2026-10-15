import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SessionLocalDataSource {
  Future<bool> hasSavedToken();
  Future<void> saveToken(String token);
  Future<void> deleteToken();
}

class SessionLocalDataSourceImpl implements SessionLocalDataSource {
  static const _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage;

  const SessionLocalDataSourceImpl(this._storage);

  @override
  Future<bool> hasSavedToken() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  @override
  Future<void> deleteToken() => _storage.delete(key: _tokenKey);
}