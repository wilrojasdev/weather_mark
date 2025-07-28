// lib/injection_container.dart
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:auto_injector/auto_injector.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather_mark/core/database_helper.dart';
import 'package:weather_mark/core/network/network_info.dart';
import 'package:weather_mark/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:weather_mark/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:weather_mark/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:weather_mark/features/auth/domain/repositories/auth_repository.dart';
import 'package:weather_mark/features/auth/domain/usecases/get_current_user.dart';
import 'package:weather_mark/features/auth/domain/usecases/login.dart';
import 'package:weather_mark/features/auth/domain/usecases/logout.dart';
import 'package:weather_mark/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:weather_mark/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:weather_mark/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:weather_mark/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_mark/features/weather/domain/repositories/weather_repository.dart';
import 'package:weather_mark/features/weather/domain/usecases/delete_weather_record.dart';
import 'package:weather_mark/features/weather/domain/usecases/get_saved_weather_history.dart';
import 'package:weather_mark/features/weather/domain/usecases/get_weather_by_location.dart';
import 'package:weather_mark/features/weather/domain/usecases/save_weather.dart';
import 'package:weather_mark/features/weather/presentation/bloc/location/location_bloc.dart';
import 'package:weather_mark/features/weather/presentation/bloc/weather/weather_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

final sl = GetIt.instance;
final injector = AutoInjector();

Future<void> init() async {
  final auth0Domain = dotenv.env['AUTH0_DOMAIN']!;
  final auth0ClientId = dotenv.env['AUTH0_CLIENT_ID']!;
  final openWeatherApiKey = dotenv.env['OPENWEATHER_API_KEY']!;

  // External dependencies
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => Connectivity());

  // Auth0
  sl.registerLazySingleton(() => Auth0(
        auth0Domain,
        auth0ClientId,
      ));

  // Database
  final databaseHelper = DatabaseHelper();
  final database = await databaseHelper.database;

  sl.registerLazySingleton<Database>(() => database);

  // Core
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(sl<Connectivity>()));

  // Auth DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(auth0: sl<Auth0>()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      database: sl<Database>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Auth UseCases
  sl.registerLazySingleton(() => Login(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUser(sl<AuthRepository>()));
  sl.registerLazySingleton(() => Logout(sl<AuthRepository>()));

  // Auth Bloc
  sl.registerFactory(() => AuthBloc(
        login: sl<Login>(),
        logout: sl<Logout>(),
        getCurrentUser: sl<GetCurrentUser>(),
      ));

  // Weather DataSources
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(
      dio: sl<Dio>(),
      apiKey: openWeatherApiKey,
    ),
  );
  sl.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(database: sl<Database>()),
  );

  // Weather Repository
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: sl<WeatherRemoteDataSource>(),
      localDataSource: sl<WeatherLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
      authRepository: sl(),
    ),
  );

  // Weather UseCases
  sl.registerLazySingleton(() => GetWeatherByLocation(sl<WeatherRepository>()));
  sl.registerLazySingleton(() => SaveWeather(sl<WeatherRepository>()));
  sl.registerLazySingleton(
      () => GetSavedWeatherHistory(sl<WeatherRepository>()));
  sl.registerLazySingleton(() => DeleteWeatherRecord(sl<WeatherRepository>()));

  // Weather Bloc
  sl.registerFactory(() => WeatherBloc(
        getWeatherByLocation: sl<GetWeatherByLocation>(),
        saveWeather: sl<SaveWeather>(),
        getSavedWeatherHistory: sl<GetSavedWeatherHistory>(),
        deleteWeatherRecord: sl<DeleteWeatherRecord>(),
      ));

  sl.registerFactory(() => LocationBloc());
}
