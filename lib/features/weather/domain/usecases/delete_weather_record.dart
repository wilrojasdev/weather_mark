// lib/features/weather/domain/usecases/save_weather.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_mark/core/usecase/usecase.dart';
import '../../../../core/error/failure.dart';

import '../repositories/weather_repository.dart';

class DeleteWeatherRecord implements UseCase<void, WeatherIdParams> {
  final WeatherRepository repository;

  DeleteWeatherRecord(this.repository);

  @override
  Future<Either<Failure, void>> call(WeatherIdParams params) async {
    return await repository.deleteWeatherRecord(params.id);
  }
}

class WeatherIdParams extends Equatable {
  final String id;

  const WeatherIdParams({required this.id});

  @override
  List<Object> get props => [id];
}
