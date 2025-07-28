// lib/features/weather/presentation/widgets/logout_dialog.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class LogoutDialog extends StatefulWidget {
  final VoidCallback onConfirm;
  final String? userName;

  const LogoutDialog({
    super.key,
    required this.onConfirm,
    this.userName,
  });

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _iconController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _blurAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _iconRotation;

  bool _cancelHovered = false;
  bool _logoutHovered = false;
  bool _cancelPressed = false;
  bool _logoutPressed = false;

  @override
  void initState() {
    super.initState();

    // Controlador principal
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Controlador para el icono
    _iconController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Animaciones
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _blurAnimation = Tween<double>(
      begin: 0.0,
      end: 15.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<double>(
      begin: -50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _iconRotation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.linear,
    ));

    // Iniciar animaciones
    _controller.forward();
    _iconController.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: _blurAnimation.value,
            sigmaY: _blurAnimation.value,
          ),
          child: Container(
            color: Colors.black.withValues(alpha: _fadeAnimation.value * 0.5),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: _buildDialogContent(context),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: const Color(0xFF0F2027).withValues(alpha: 0.5),
            blurRadius: 60,
            offset: const Offset(0, 30),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0F2027).withValues(alpha: 0.95),
                  const Color(0xFF203A43).withValues(alpha: 0.95),
                  const Color(0xFF2C5364).withValues(alpha: 0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                // Contenido
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icono animado
                      _buildAnimatedIcon(),

                      const SizedBox(height: 28),

                      // Título
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Colors.blueAccent],
                        ).createShader(bounds),
                        child: const Text(
                          '¿Cerrar sesión?',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Descripción
                      Text(
                        'Tendrás que volver a iniciar sesión para\nacceder a tu información del clima',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withValues(alpha: 0.7),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // Información adicional
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.blue.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade300,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Tu historial permanecerá guardado',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue.shade200,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      // Botones
                      Row(
                        children: [
                          // Botón Cancelar
                          Expanded(
                            child: _buildCancelButton(context),
                          ),
                          const SizedBox(width: 16),
                          // Botón Cerrar sesión
                          Expanded(
                            child: _buildLogoutButton(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _iconController,
      builder: (context, child) {
        return Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Círculo exterior animado
              Transform.rotate(
                angle: _iconRotation.value,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                ),
              ),
              // Icono central
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _cancelHovered = true),
      onExit: (_) => setState(() => _cancelHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _cancelPressed = true),
        onTapUp: (_) => setState(() => _cancelPressed = false),
        onTapCancel: () => setState(() => _cancelPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.identity()
            ..scale(_cancelPressed ? 0.95 : (_cancelHovered ? 1.02 : 1.0)),
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _cancelHovered
                  ? [
                      Colors.white.withValues(alpha: 0.25),
                      Colors.white.withValues(alpha: 0.2)
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.1)
                    ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: _cancelHovered ? 0.5 : 0.3),
              width: 1.5,
            ),
            boxShadow: _cancelHovered
                ? [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _controller.reverse().then((_) {
                  Navigator.of(context).pop();
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cancelar',
                      style: TextStyle(
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

  Widget _buildLogoutButton(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _logoutHovered = true),
      onExit: (_) => setState(() => _logoutHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _logoutPressed = true),
        onTapUp: (_) => setState(() => _logoutPressed = false),
        onTapCancel: () => setState(() => _logoutPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.identity()
            ..scale(_logoutPressed ? 0.95 : (_logoutHovered ? 1.02 : 1.0)),
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _logoutHovered
                  ? [
                      const Color(0xFF2C5364),
                      const Color(0xFF203A43),
                    ]
                  : [
                      const Color(0xFF203A43),
                      const Color(0xFF0F2027),
                    ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F2027)
                    .withValues(alpha: _logoutHovered ? 0.6 : 0.4),
                blurRadius: _logoutHovered ? 25 : 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _controller.reverse().then((_) {
                  Navigator.of(context).pop();
                  widget.onConfirm();
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cerrar sesión',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
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
