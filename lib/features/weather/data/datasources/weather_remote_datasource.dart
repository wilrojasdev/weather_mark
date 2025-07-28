// lib/features/weather/data/datasources/weather_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:weather_mark/core/constants/constants.dart';
import 'package:weather_mark/core/error/exceptions.dart';
import 'package:weather_mark/features/weather/data/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;
  final String apiKey;

  WeatherRemoteDataSourceImpl({
    required this.dio,
    required this.apiKey,
  });

  @override
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon) async {
    try {
      final response = await dio.get(
        baseUrlOpenWeather,
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apiKey,
          'units': 'metric',
          'lang': 'es'
        },
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw ServerException(response.statusMessage);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
