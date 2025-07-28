import 'package:flutter/material.dart';

class AnimatedPattern extends StatefulWidget {
  const AnimatedPattern({super.key});

  @override
  State<AnimatedPattern> createState() => _AnimatedPatternState();
}

class _AnimatedPatternState extends State<AnimatedPattern>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _PatternPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _PatternPainter extends CustomPainter {
  final double animationValue;

  _PatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    final offset = animationValue * spacing * 2;

    for (double i = -size.height - spacing;
        i < size.width + size.height;
        i += spacing) {
      canvas.drawLine(
        Offset(i + offset, 0),
        Offset(i + offset - size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
