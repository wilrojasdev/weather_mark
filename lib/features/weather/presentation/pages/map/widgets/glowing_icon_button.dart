import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlowingIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const GlowingIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  State<GlowingIconButton> createState() => _GlowingIconButtonState();
}

class _GlowingIconButtonState extends State<GlowingIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onPressed();
        },
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.3),
                border: Border.all(
                  color: widget.color.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: [
                  if (_isHovered)
                    BoxShadow(
                      color: widget.color
                          .withValues(alpha: 0.3 + _glowAnimation.value * 0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Center(
                child: Icon(
                  widget.icon,
                  color: _isHovered
                      ? widget.color
                      : Colors.white.withValues(alpha: 0.8),
                  size: 20,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
