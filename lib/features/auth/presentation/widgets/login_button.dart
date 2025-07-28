import 'package:flutter/material.dart';

class LoginButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const LoginButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  State<LoginButton> createState() => LoginButtonState();
}

class LoginButtonState extends State<LoginButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(_isHovered && !widget.isLoading ? 1.05 : 1.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: widget.isLoading
                  ? [Colors.grey.shade600, Colors.grey.shade700]
                  : _isHovered
                      ? [Colors.blue.shade600, Colors.blue.shade800]
                      : [Colors.blue.shade500, Colors.blue.shade700],
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isLoading
                    ? Colors.grey.withValues(alpha: 0.3)
                    : Colors.blue.withValues(alpha: _isHovered ? 0.6 : 0.4),
                blurRadius: _isHovered ? 20 : 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.isLoading ? 'Conectando...' : 'Iniciar sesión',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
