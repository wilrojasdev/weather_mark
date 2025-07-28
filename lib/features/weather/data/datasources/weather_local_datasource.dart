// lib/features/weather/data/datasources/weather_local_datasource.dart
import 'package:sqflite/sqflite.dart';
import 'package:weather_mark/features/weather/data/models/weather_model.dart';

abstract class WeatherLocalDataSource {
  Future<void> saveWeather(WeatherModel weather, String userId);
  Future<List<WeatherModel>> getSavedWeatherHistory(String userId);
  Future<void> deleteWeather(String id, String userId);
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final Database database;
  static const String weatherTable = 'weather_history';

  WeatherLocalDataSourceImpl({required this.database});

  @override
  Future<void> saveWeather(WeatherModel weather, String userId) async {
    final weatherWithUserId = weather.copyWith(userId: userId);
    await database.insert(
      weatherTable,
      weatherWithUserId.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<WeatherModel>> getSavedWeatherHistory(String userId) async {
    final maps = await database.query(
      weatherTable,
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return maps.map((map) => WeatherModel.fromJson(map)).toList();
  }

  @override
  Future<void> deleteWeather(String id, String userId) async {
    await database.delete(
      weatherTable,
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );
  }
}
