// lib/features/weather/presentation/bloc/weather_event.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/weather.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class LoadWeatherForLocation extends WeatherEvent {
  final double latitude;
  final double longitude;

  const LoadWeatherForLocation({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

class SaveCurrentWeather extends WeatherEvent {
  final Weather weather;

  const SaveCurrentWeather({required this.weather});

  @override
  List<Object> get props => [weather];
}

class DeleteWeather extends WeatherEvent {
  final String weatherId;

  const DeleteWeather({required this.weatherId});

  @override
  List<Object> get props => [weatherId];
}

class LoadWeatherHistory extends WeatherEvent {}
