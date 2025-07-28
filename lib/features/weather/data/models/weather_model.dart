// lib/features/weather/data/models/weather_model.dart
import 'package:weather_mark/features/weather/domain/entities/weather.dart';

class WeatherModel extends Weather {
  final String? id;
  final String? userId;

  const WeatherModel({
    this.id,
    this.userId,
    required super.name,
    required super.temperature,
    required super.feelsLike,
    required super.humidity,
    required super.windSpeed,
    required super.pressure,
    required super.description,
    required super.icon,
    required super.visibility,
    required super.latitude,
    required super.longitude,
    super.savedAt,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('coord')) {
      return WeatherModel(
        name: json['name'] as String,
        temperature: (json['main']['temp'] as num).toDouble(),
        feelsLike: (json['main']['feels_like'] as num).toDouble(),
        humidity: json['main']['humidity'] as int,
        windSpeed: (json['wind']['speed'] as num).toDouble(),
        pressure: json['main']['pressure'] as int,
        description: json['weather'][0]['description'] as String,
        icon: json['weather'][0]['icon'] as String,
        visibility: json['visibility'] as int,
        latitude: (json['coord']['lat'] as num).toDouble(),
        longitude: (json['coord']['lon'] as num).toDouble(),
      );
    } else {
      return WeatherModel(
        id: json['id'] as String?,
        userId: json['userId'] as String?,
        name: json['name'] as String,
        temperature: (json['temperature'] as num).toDouble(),
        feelsLike: (json['feelsLike'] as num).toDouble(),
        humidity: json['humidity'] as int,
        windSpeed: (json['windSpeed'] as num).toDouble(),
        pressure: json['pressure'] as int,
        description: json['description'] as String,
        icon: json['icon'] as String,
        visibility: json['visibility'] as int,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        savedAt: json['savedAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['savedAt'] as int)
            : null,
      );
    }
  }

  factory WeatherModel.fromEntity(Weather weather, String userId) {
    return WeatherModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      name: weather.name,
      temperature: weather.temperature,
      feelsLike: weather.feelsLike,
      humidity: weather.humidity,
      windSpeed: weather.windSpeed,
      pressure: weather.pressure,
      description: weather.description,
      icon: weather.icon,
      visibility: weather.visibility,
      latitude: weather.latitude,
      longitude: weather.longitude,
      savedAt: weather.savedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'userId': userId,
      'name': name,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'pressure': pressure,
      'description': description,
      'icon': icon,
      'visibility': visibility,
      'latitude': latitude,
      'longitude': longitude,
      'savedAt': savedAt?.millisecondsSinceEpoch ??
          DateTime.now().millisecondsSinceEpoch,
    };
  }

  @override
  WeatherModel copyWith({
    String? id,
    String? userId,
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
    return WeatherModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
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
}
