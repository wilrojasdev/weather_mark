import 'package:flutter/material.dart';
import 'package:weather_mark/features/weather/data/models/weather_model.dart';
import 'package:weather_mark/features/weather/presentation/helpers/weather_utils.dart';
import 'package:weather_mark/features/weather/presentation/pages/history/widgets/weather_detail.dart';
import 'package:weather_mark/features/weather/presentation/pages/history/widgets/weather_header.dart';

class AnimatedWeatherCard extends StatefulWidget {
  final WeatherModel weather;
  final int index;
  final VoidCallback onDelete;

  const AnimatedWeatherCard({
    super.key,
    required this.weather,
    required this.index,
    required this.onDelete,
  });

  @override
  State<AnimatedWeatherCard> createState() => _AnimatedWeatherCardState();
}

class _AnimatedWeatherCardState extends State<AnimatedWeatherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400 + (widget.index * 60)),
      vsync: this,
    );

    _scaleAnimation = Tween(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weather = widget.weather;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapUp: (_) => setState(() => _isPressed = false),
                onTapCancel: () => setState(() => _isPressed = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        WeatherUtils.getWeatherGradientStart(weather.icon),
                        WeatherUtils.getWeatherGradientEnd(weather.icon),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: WeatherUtils.getWeatherColor(weather.icon)
                            .withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WeatherHeader(
                          weather: weather,
                          onDelete: widget.onDelete,
                        ),
                        const SizedBox(height: 16),
                        WeatherDetails(weather: weather),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_outlined,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              weather.savedAt != null
                                  ? WeatherUtils.formatDate(weather.savedAt!)
                                  : 'Fecha desconocida',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
