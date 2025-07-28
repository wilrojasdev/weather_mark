// lib/features/weather/presentation/widgets/weather_header.dart
import 'package:flutter/material.dart';
import 'package:weather_mark/features/weather/domain/entities/weather.dart';

class WeatherHeader extends StatelessWidget {
  final Weather weather;
  final VoidCallback onClose;

  const WeatherHeader({
    super.key,
    required this.weather,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location name
              if (weather.name.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        weather.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
              // Coordinates
              Text(
                '${weather.latitude.toStringAsFixed(4)}, ${weather.longitude.toStringAsFixed(4)}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        // Close button
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
            onPressed: onClose,
            padding: const EdgeInsets.all(8),
          ),
        ),
      ],
    );
  }
}
