// lib/features/auth/data/datasources/auth_local_datasource.dart
import 'package:sqflite/sqflite.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weather_mark/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<void> saveTokens(String accessToken, String? refreshToken);
  Future<Map<String, String?>> getTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Database database;
  final FlutterSecureStorage secureStorage;

  static const String userTable = 'users';
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';

  AuthLocalDataSourceImpl({
    required this.database,
    required this.secureStorage,
  });

  @override
  Future<void> cacheUser(UserModel user) async {
    await database.insert(
      userTable,
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final maps = await database.query(userTable, limit: 1);
    if (maps.isNotEmpty) {
      final tokens = await getTokens();
      final userData = Map<String, dynamic>.from(maps.first);
      userData['accessToken'] = tokens['access'];
      userData['refreshToken'] = tokens['refresh'];
      return UserModel.fromJson(userData);
    }
    return null;
  }

  @override
  Future<void> saveTokens(String accessToken, String? refreshToken) async {
    await secureStorage.write(key: accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await secureStorage.write(key: refreshTokenKey, value: refreshToken);
    }
  }

  @override
  Future<Map<String, String?>> getTokens() async {
    final access = await secureStorage.read(key: accessTokenKey);
    final refresh = await secureStorage.read(key: refreshTokenKey);
    return {'access': access, 'refresh': refresh};
  }

  @override
  Future<void> clearCache() async {
    await database.delete(userTable);
    await secureStorage.delete(key: accessTokenKey);
    await secureStorage.delete(key: refreshTokenKey);
  }
}
