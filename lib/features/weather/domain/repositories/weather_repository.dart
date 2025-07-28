// lib/features/weather/domain/repositories/weather_repository.dart
import 'package:dartz/dartz.dart';
import 'package:weather_mark/core/error/failure.dart';
import 'package:weather_mark/features/weather/data/models/weather_model.dart';
import 'package:weather_mark/features/weather/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getWeatherByLocation(double lat, double lon);
  Future<Either<Failure, void>> saveWeather(Weather weather);
  Future<Either<Failure, List<WeatherModel>>> getSavedWeatherHistory();
  Future<Either<Failure, void>> deleteWeatherRecord(String id);
}
