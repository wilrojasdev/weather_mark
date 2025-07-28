// lib/features/weather/presentation/widgets/map/map_animations.dart
import 'package:flutter/material.dart';

class MapAnimations {
  final TickerProvider vsync;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _rotationController;

  Animation<double> get pulseAnimation => _pulseAnimation;
  AnimationController get rotationController => _rotationController;

  MapAnimations({required this.vsync});

  void init() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    )..repeat();
  }

  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
  }
}
