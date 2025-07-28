import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:weather_mark/features/auth/presentation/pages/loading_page.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    super.key,
    required Animation<double> pulseAnimation,
    required this.widget,
    required AnimationController rotationController,
  })  : _pulseAnimation = pulseAnimation,
        _rotationController = rotationController;

  final Animation<double> _pulseAnimation;
  final LoadingPage widget;
  final AnimationController _rotationController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (widget.isLogout ? Colors.orange : Colors.white)
                      .withValues(alpha: 0.3),
                  (widget.isLogout ? Colors.orange : Colors.white)
                      .withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: (widget.isLogout ? Colors.orange : Colors.blue)
                      .withValues(alpha: 0.5),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: widget.isLogout
                          ? -_rotationController.value * 2 * math.pi
                          : _rotationController.value * 2 * math.pi,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Icon(
                  widget.isLogout ? Icons.logout_rounded : Icons.cloud,
                  size: 50,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
