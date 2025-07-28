// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:weather_mark/core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<Credentials> login();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Auth0 auth0;

  AuthRemoteDataSourceImpl({required this.auth0});

  @override
  Future<Credentials> login() async {
    try {
      final credentials =
          await auth0.webAuthentication(scheme: 'https').login();
      return credentials;
    } catch (e) {
      throw AuthenticationException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await auth0.webAuthentication(scheme: 'https').logout();
    } catch (e) {
      throw AuthenticationException();
    }
  }
}
