// lib/features/weather/domain/entities/weather.dart
import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String name;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String description;
  final String icon;
  final int visibility;
  final double latitude;
  final double longitude;
  final DateTime? savedAt;

  const Weather({
    required this.name,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.description,
    required this.icon,
    required this.visibility,
    required this.latitude,
    required this.longitude,
    this.savedAt,
  });

  Weather copyWith({
    String? name,
    double? temperature,
    double? feelsLike,
    int? humidity,
    double? windSpeed,
    int? pressure,
    String? description,
    String? icon,
    int? visibility,
    double? latitude,
    double? longitude,
    DateTime? savedAt,
  }) {
    return Weather(
      name: name ?? this.name,
      temperature: temperature ?? this.temperature,
      feelsLike: feelsLike ?? this.feelsLike,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      pressure: pressure ?? this.pressure,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      visibility: visibility ?? this.visibility,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  @override
  List<Object?> get props => [
        name,
        temperature,
        feelsLike,
        humidity,
        windSpeed,
        pressure,
        description,
        icon,
        visibility,
        latitude,
        longitude,
        savedAt,
      ];
}
