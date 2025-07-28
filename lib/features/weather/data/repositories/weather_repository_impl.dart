// lib/features/weather/data/repositories/weather_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:weather_mark/features/auth/domain/repositories/auth_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_local_datasource.dart';
import '../datasources/weather_remote_datasource.dart';
import '../models/weather_model.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final AuthRepository authRepository;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.authRepository,
  });

  @override
  Future<Either<Failure, Weather>> getWeatherByLocation(
      double lat, double lon) async {
    if (await networkInfo.isConnected) {
      try {
        final weather =
            await remoteDataSource.getWeatherByCoordinates(lat, lon);
        return Right(weather);
      } on ServerException {
        return const Left(ServerFailure('server error'));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveWeather(Weather weather) async {
    try {
      final userResult = await authRepository.getCurrentUser();

      return userResult.fold(
        (failure) => Left(failure),
        (user) async {
          final weatherModel = WeatherModel.fromEntity(weather, user!.id);

          await localDataSource.saveWeather(weatherModel, user.id);
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<WeatherModel>>> getSavedWeatherHistory() async {
    try {
      final userResult = await authRepository.getCurrentUser();

      return userResult.fold(
        (failure) => Left(failure),
        (user) async {
          final weatherModels =
              await localDataSource.getSavedWeatherHistory(user!.id);
          return Right(weatherModels);
        },
      );
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteWeatherRecord(String id) async {
    try {
      final userResult = await authRepository.getCurrentUser();

      return userResult.fold(
        (failure) => Left(failure),
        (user) async {
          await localDataSource.deleteWeather(id, user!.id);
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
