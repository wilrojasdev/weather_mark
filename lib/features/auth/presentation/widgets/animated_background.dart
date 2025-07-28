import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedBackground extends StatelessWidget {
  final AnimationController rotationController;

  const AnimatedBackground({
    super.key,
    required this.rotationController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F2027),
            Color(0xFF203A43),
            Color(0xFF2C5364),
          ],
        ),
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: rotationController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlesPainter(
                  animation: rotationController.value,
                ),
                size: Size.infinite,
              );
            },
          ),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ParticlesPainter extends CustomPainter {
  final double animation;

  ParticlesPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final random = math.Random(42);

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3 + 1;
      final offset = Offset(
        x + math.sin(animation * 2 * math.pi + i) * 20,
        y + math.cos(animation * 2 * math.pi + i) * 20,
      );

      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
