import 'package:flutter/material.dart';
import 'package:weather_mark/features/weather/domain/entities/weather.dart';
import 'package:weather_mark/features/weather/presentation/pages/history/widgets/weather_header.dart';
import 'package:weather_mark/features/weather/presentation/pages/map/widgets/weather_detail.dart';
import 'package:weather_mark/features/weather/presentation/pages/map/widgets/weather_main_info.dart';
import 'package:weather_mark/features/weather/presentation/pages/map/widgets/weather_save_button.dart';

class WeatherContent extends StatelessWidget {
  final Weather weather;
  final VoidCallback? onSave;
  final VoidCallback onClose;

  const WeatherContent({
    super.key,
    required this.weather,
    this.onSave,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSaved = weather.savedAt != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with close button and location name
          WeatherHeader(
            weather: weather,
            onDelete: onClose,
          ),

          const SizedBox(height: 20),

          // Main weather info
          WeatherMainInfo(weather: weather),

          const SizedBox(height: 20),

          // Weather details
          WeatherDetailsCard(weather: weather),

          const SizedBox(height: 20),

          // Save button
          WeatherSaveButton(
            isSaved: isSaved,
            onSave: onSave,
          ),
        ],
      ),
    );
  }
}

class WeatherLoadingContent extends StatelessWidget {
  const WeatherLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Cargando información del clima...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
