// lib/features/weather/domain/usecases/get_weather_by_location.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_mark/core/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetWeatherByLocation implements UseCase<Weather, LocationParams> {
  final WeatherRepository repository;

  GetWeatherByLocation(this.repository);

  @override
  Future<Either<Failure, Weather>> call(LocationParams params) async {
    return await repository.getWeatherByLocation(
        params.latitude, params.longitude);
  }
}

class LocationParams extends Equatable {
  final double latitude;
  final double longitude;

  const LocationParams({required this.latitude, required this.longitude});

  @override
  List<Object> get props => [latitude, longitude];
}
