import '../../domain/repositories/session_repository.dart';
import '../datasources/session_local_data_source.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionLocalDataSource _dataSource;
  const SessionRepositoryImpl(this._dataSource);

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await _dataSource.hasSavedToken();
    } catch (_) {
      // If secure storage can't be read, treat the user as logged out.
      return false;
    }
  }
}