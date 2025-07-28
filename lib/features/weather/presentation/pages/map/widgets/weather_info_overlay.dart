// lib/features/weather/presentation/widgets/weather_info_overlay.dart
import 'package:flutter/material.dart';
import 'package:weather_mark/features/weather/domain/entities/weather.dart';
import 'package:weather_mark/features/weather/presentation/pages/map/widgets/weather_content.dart';

class WeatherInfoOverlay extends StatefulWidget {
  final Weather? weather;
  final bool isLoading;
  final VoidCallback? onSave;
  final VoidCallback onClose;

  const WeatherInfoOverlay({
    super.key,
    this.weather,
    required this.isLoading,
    this.onSave,
    required this.onClose,
  });

  @override
  State<WeatherInfoOverlay> createState() => _WeatherInfoOverlayState();
}

class _WeatherInfoOverlayState extends State<WeatherInfoOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 10;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height * 0.85,
          minHeight: 200,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3C72),
              Color(0xFF2A5298),
            ],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),

            // Content
            Flexible(
              child: widget.isLoading
                  ? const WeatherLoadingContent()
                  : WeatherContent(
                      weather: widget.weather!,
                      onSave: widget.onSave,
                      onClose: widget.onClose,
                    ),
            ),

            // Bottom padding
            SizedBox(height: bottomPadding),
          ],
        ),
      ),
    );
  }
}
