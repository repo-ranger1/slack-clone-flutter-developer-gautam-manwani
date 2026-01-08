import 'package:slack_clone_gautam_manwani/core/utils/storage/app_storage.dart';
import 'package:slack_clone_gautam_manwani/core/utils/storage/app_session.dart';
import 'package:slack_clone_gautam_manwani/data/datasources/auth_datasource.dart';
import 'package:slack_clone_gautam_manwani/domain/entities/user_entity.dart';
import 'package:slack_clone_gautam_manwani/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;
  final AppStorage _storage;
  final AppSession _session;

  AuthRepositoryImpl({
    required AuthDataSource dataSource,
    AppStorage? storage,
    AppSession? session,
  })  : _dataSource = dataSource,
        _storage = storage ?? AppStorage(),
        _session = session ?? AppSession();

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final userModel = await _dataSource.login(email, password);

      // Save to storage
      _storage.isLoggedIn.v = true;
      _storage.userId.v = userModel.id;
      _storage.userName.v = userModel.name;
      _storage.userEmail.v = userModel.email;

      // Save to session
      _session.user = userModel.toEntity();

      return userModel.toEntity();
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dataSource.logout();
      _session.clear();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      // Check session first
      if (_session.user != null) {
        return _session.user;
      }

      // Check storage
      final isLoggedIn = _storage.isLoggedIn.v ?? false;
      if (!isLoggedIn) return null;

      // Get from data source
      final userModel = await _dataSource.getCurrentUser();
      if (userModel != null) {
        _session.user = userModel.toEntity();
        return userModel.toEntity();
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _dataSource.isLoggedIn();
  }
}
