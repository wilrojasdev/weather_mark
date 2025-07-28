import 'package:flutter/material.dart';

class WeatherLogo extends StatelessWidget {
  const WeatherLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.2),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.cloud,
            size: 80,
            color: Colors.white.withValues(alpha: 0.9),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: Icon(
              Icons.wb_sunny,
              size: 40,
              color: Colors.yellow.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
