// lib/features/weather/presentation/widgets/map/map_utils.dart
import 'package:flutter/material.dart';

class MapUtils {
  static Color getWeatherColor(String iconCode) {
    if (iconCode.contains('01')) return Colors.orange; // Clear
    if (iconCode.contains('02')) return Colors.amber; // Few clouds
    if (iconCode.contains('03') || iconCode.contains('04')) {
      return Colors.grey; // Clouds
    }
    if (iconCode.contains('09') || iconCode.contains('10')) {
      return Colors.blue; // Rain
    }
    if (iconCode.contains('11')) return Colors.deepPurple; // Thunderstorm
    if (iconCode.contains('13')) return Colors.lightBlue; // Snow
    if (iconCode.contains('50')) return Colors.blueGrey; // Mist
    return Colors.grey;
  }
}
