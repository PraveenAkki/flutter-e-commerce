abstract class AuthRepository {
  Future<void> login({required String email, required String password});
  Future<void> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> resetPassword({required String email, required String newPassword});
  Future<void> logout();
}