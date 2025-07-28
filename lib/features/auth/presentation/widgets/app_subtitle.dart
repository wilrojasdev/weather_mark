import 'package:flutter/material.dart';

class AppSubtitle extends StatelessWidget {
  const AppSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Tu clima en tiempo real',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white.withValues(alpha: 0.7),
        letterSpacing: 1,
      ),
    );
  }
}
