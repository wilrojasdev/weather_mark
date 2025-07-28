// lib/features/weather/presentation/widgets/weather_save_button.dart
import 'package:flutter/material.dart';

class WeatherSaveButton extends StatelessWidget {
  final bool isSaved;
  final VoidCallback? onSave;

  const WeatherSaveButton({
    super.key,
    required this.isSaved,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSaved
                ? [Colors.green.shade600, Colors.green.shade700]
                : [Colors.white.withValues(alpha: 0.9), Colors.white],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isSaved
                  ? Colors.green.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isSaved ? null : onSave,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSaved ? Icons.check_circle : Icons.save_outlined,
                    size: 22,
                    color: isSaved ? Colors.white : const Color(0xFF203A43),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isSaved ? 'Guardado' : 'Guardar ubicación',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSaved ? Colors.white : const Color(0xFF203A43),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
