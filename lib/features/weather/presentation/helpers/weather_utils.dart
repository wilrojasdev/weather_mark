import 'package:flutter/material.dart';

class WeatherUtils {
  static String formatCoordinates(double lat, double lon) {
    final latDir = lat >= 0 ? 'N' : 'S';
    final lonDir = lon >= 0 ? 'E' : 'O';
    return '${lat.abs().toStringAsFixed(2)}°$latDir, ${lon.abs().toStringAsFixed(2)}°$lonDir';
  }

  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Guardado hace un momento';
    } else if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return 'Hace $minutes ${minutes == 1 ? 'minuto' : 'minutos'}';
    } else if (difference.inDays < 1) {
      final hours = difference.inHours;
      return 'Hace $hours ${hours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return 'Hace $days ${days == 1 ? 'día' : 'días'}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Hace $weeks ${weeks == 1 ? 'semana' : 'semanas'}';
    } else {
      return '${date.day}/${date.month}/${date.year} a las ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  static Color getWeatherColor(String iconCode) {
    final code = iconCode.substring(0, 2);
    switch (code) {
      case '01':
        return Colors.orange;
      case '02':
      case '03':
      case '04':
        return Colors.blueGrey;
      case '09':
      case '10':
        return Colors.blue;
      case '11':
        return Colors.deepPurple;
      case '13':
        return Colors.lightBlue;
      case '50':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  static Color getWeatherGradientStart(String iconCode) {
    final baseColor = getWeatherColor(iconCode);
    final isNight = iconCode.contains('n');
    return isNight
        ? baseColor.withValues(alpha: 0.8)
        : baseColor.withValues(alpha: 0.7);
  }

  static Color getWeatherGradientEnd(String iconCode) {
    final baseColor = getWeatherColor(iconCode);
    final isNight = iconCode.contains('n');
    return isNight ? const Color(0xFF1a237e) : baseColor.withValues(alpha: 0.4);
  }
}
