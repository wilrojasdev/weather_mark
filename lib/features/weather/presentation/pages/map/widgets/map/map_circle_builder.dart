// lib/features/weather/presentation/widgets/map/map_circle_builder.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../bloc/weather/weather_state.dart';
import 'map_utils.dart';

class MapCircleBuilder {
  Circle createCurrentLocationCircle(LatLng location) {
    return Circle(
      circleId: const CircleId('current_location_circle'),
      center: location,
      radius: 50,
      fillColor: Colors.blue.withValues(alpha: 0.1),
      strokeColor: Colors.blue.withValues(alpha: 0.5),
      strokeWidth: 2,
    );
  }

  Circle createWeatherCircle({
    required LatLng location,
    required bool isLoading,
    required WeatherState weatherState,
  }) {
    if (isLoading) {
      return Circle(
        circleId: const CircleId('weather_loading_circle'),
        center: location,
        radius: 80,
        fillColor: Colors.blue.withValues(alpha: 0.1),
        strokeColor: Colors.blue.withValues(alpha: 0.5),
        strokeWidth: 3,
      );
    }

    Color circleColor = Colors.grey;
    if (weatherState is WeatherLoaded) {
      circleColor = MapUtils.getWeatherColor(weatherState.weather.icon);
    }

    return Circle(
      circleId: const CircleId('weather_location_circle'),
      center: location,
      radius: 80,
      fillColor: circleColor.withValues(alpha: 0.1),
      strokeColor: circleColor.withValues(alpha: 0.3),
      strokeWidth: 3,
    );
  }

  Set<Circle> updateAnimatedCircles({
    required Set<Circle> circles,
    required Animation<double> pulseAnimation,
  }) {
    return circles.map((circle) {
      if (circle.circleId.value == 'current_location_circle') {
        // Animar el círculo de ubicación actual
        return circle.copyWith(
          radiusParam: 50 + (pulseAnimation.value * 20),
          fillColorParam: Colors.blue
              .withValues(alpha: 0.1 * (1 - pulseAnimation.value * 0.5)),
        );
      } else if (circle.circleId.value == 'weather_loading_circle') {
        // Animar el círculo de carga del clima
        return circle.copyWith(
          radiusParam: 80 + (pulseAnimation.value * 30),
          strokeColorParam:
              Colors.blue.withValues(alpha: 0.3 + (pulseAnimation.value * 0.4)),
          fillColorParam: Colors.blue
              .withValues(alpha: 0.05 + (pulseAnimation.value * 0.05)),
        );
      }
      return circle;
    }).toSet();
  }
}
