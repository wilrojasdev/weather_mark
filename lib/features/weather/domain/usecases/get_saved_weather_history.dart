// lib/features/weather/domain/usecases/get_saved_weather_history.dart
import 'package:dartz/dartz.dart';
import 'package:weather_mark/core/usecase/usecase.dart';
import 'package:weather_mark/features/weather/data/models/weather_model.dart';
import '../../../../core/error/failure.dart';
import '../repositories/weather_repository.dart';

class GetSavedWeatherHistory implements UseCase<List<WeatherModel>, NoParams> {
  final WeatherRepository repository;

  GetSavedWeatherHistory(this.repository);

  @override
  Future<Either<Failure, List<WeatherModel>>> call(NoParams params) async {
    return await repository.getSavedWeatherHistory();
  }
}
