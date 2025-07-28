// lib/features/weather/presentation/bloc/weather_state.dart
import 'package:equatable/equatable.dart';
import 'package:weather_mark/features/weather/data/models/weather_model.dart';
import '../../../domain/entities/weather.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherLoading extends WeatherState {}

class WeatherSaving extends WeatherState {
  final Weather weather;

  const WeatherSaving({required this.weather});
}

class WeatherSaved extends WeatherState {
  final Weather weather;

  const WeatherSaved({required this.weather});
}

class WeatherLoaded extends WeatherState {
  final Weather weather;

  const WeatherLoaded({required this.weather});

  @override
  List<Object> get props => [weather];
}

class WeatherHistoryLoaded extends WeatherState {
  final List<WeatherModel> weatherHistory;

  const WeatherHistoryLoaded({required this.weatherHistory});

  @override
  List<Object> get props => [weatherHistory];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError({required this.message});

  @override
  List<Object> get props => [message];
}
