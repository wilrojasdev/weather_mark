// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login() async {
    if (await networkInfo.isConnected) {
      try {
        final credentials = await remoteDataSource.login();
        final user = UserModel(
          id: credentials.user.sub,
          email: credentials.user.email ?? '',
          name: credentials.user.name ?? '',
          picture: credentials.user.pictureUrl?.toString(),
        );

        await localDataSource.cacheUser(user);
        await localDataSource.saveTokens(
          credentials.accessToken,
          credentials.refreshToken,
        );

        return Right(user);
      } on WebAuthenticationException catch (e) {
        if (e.code == 'a0.session.user_cancelled' ||
            e.message.contains('user_cancelled') ||
            e.message.contains('User cancelled') ||
            e.message.contains('Login cancelled')) {
          return Left(UserCancelledFailure());
        }

        return Left(ServerFailure(e.message));
      } catch (e) {
        if (e.toString().contains('cancelled') ||
            e.toString().contains('dismissed')) {
          return Left(UserCancelledFailure());
        }

        return const Left(ServerFailure('Error al iniciar sesión'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearCache();
      return const Right(null);
    } on AuthenticationException {
      return Left(AuthenticationFailure());
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
