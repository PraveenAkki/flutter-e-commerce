import '../repositories/session_repository.dart';

class CheckSessionUseCase {
  final SessionRepository _repository;
  const CheckSessionUseCase(this._repository);

  Future<bool> call() => _repository.isLoggedIn();
}