import 'package:flutter/material.dart';
import 'package:weather_mark/features/weather/data/models/weather_model.dart';
import 'package:weather_mark/features/weather/presentation/pages/history/widgets/weather_icon.dart';

class WeatherDetails extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetails({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WeatherIcon(weather: weather),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.temperature.round()}',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          '°C',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weather.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  ...[
                    const SizedBox(height: 2),
                    Text(
                      'Sensación ${weather.feelsLike.round()}°',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildAdditionalInfo(context),
      ],
    );
  }

  Widget _buildAdditionalInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailItem(
            icon: Icons.water_drop_outlined,
            value: '${weather.humidity}%',
            label: 'Humedad',
          ),
          _buildDetailItem(
            icon: Icons.air,
            value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
            label: 'Viento',
          ),
          _buildDetailItem(
            icon: Icons.compress,
            value: '${weather.pressure} hPa',
            label: 'Presión',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
