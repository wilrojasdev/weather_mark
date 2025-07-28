// lib/features/weather/domain/usecases/save_weather.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_mark/core/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class SaveWeather implements UseCase<void, SaveWeatherParams> {
  final WeatherRepository repository;

  SaveWeather(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveWeatherParams params) async {
    return await repository.saveWeather(params.weather);
  }
}

class SaveWeatherParams extends Equatable {
  final Weather weather;

  const SaveWeatherParams({required this.weather});

  @override
  List<Object> get props => [weather];
}
