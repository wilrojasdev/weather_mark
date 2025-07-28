import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weather_mark/features/weather/data/models/weather_model.dart';

class WeatherIcon extends StatelessWidget {
  final WeatherModel weather;

  const WeatherIcon({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag:
          'weather-icon-${weather.id}-${weather.latitude}-${weather.longitude}',
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: CachedNetworkImage(
            imageUrl:
                'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
            fit: BoxFit.cover,
            placeholder: (_, __) => Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.5)),
              ),
            ),
            errorWidget: (_, __, ___) => Icon(
              Icons.error,
              size: 40,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}
