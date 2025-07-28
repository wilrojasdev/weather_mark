// lib/features/weather/presentation/widgets/weather_details_card.dart
import 'package:flutter/material.dart';
import 'package:weather_mark/features/weather/domain/entities/weather.dart';

class WeatherDetailsCard extends StatelessWidget {
  final Weather weather;

  const WeatherDetailsCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          WeatherDetailRow(
            icon: Icons.water_drop_outlined,
            label: 'Humedad',
            value: '${weather.humidity}%',
          ),
          const SizedBox(height: 16),
          WeatherDetailRow(
            icon: Icons.air,
            label: 'Viento',
            value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
          ),
          const SizedBox(height: 16),
          WeatherDetailRow(
            icon: Icons.compress,
            label: 'Presión',
            value: '${weather.pressure} hPa',
          ),
          const SizedBox(height: 16),
          WeatherDetailRow(
            icon: Icons.visibility_outlined,
            label: 'Visibilidad',
            value: weather.visibility >= 1000
                ? '${(weather.visibility / 1000).toStringAsFixed(1)} km'
                : '${weather.visibility} m',
          ),
        ],
      ),
    );
  }
}

class WeatherDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
