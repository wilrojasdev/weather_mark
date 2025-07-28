// lib/features/auth/presentation/widgets/auth_loading_screen.dart
import 'package:flutter/material.dart';
import 'package:weather_mark/features/auth/presentation/widgets/adittional_information.dart';
import 'package:weather_mark/features/auth/presentation/widgets/animated_logo.dart';

class LoadingPage extends StatefulWidget {
  final bool isLogout;

  const LoadingPage({
    super.key,
    required this.isLogout,
  });

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  int _messageIndex = 0;
  late List<String> _messages;

  @override
  void initState() {
    super.initState();
    _messages = widget.isLogout
        ? [
            'Cerrando sesión',
            'Guardando tus preferencias',
            'Limpiando datos locales',
            'Casi listo...',
          ]
        : [
            'Conectando con Auth0',
            'Verificando credenciales',
            'Preparando tu sesión',
            'Casi listo...',
          ];

    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    Future.delayed(const Duration(seconds: 3), _changeMessage);
  }

  void _changeMessage() {
    if (mounted) {
      setState(() {
        _messageIndex = (_messageIndex + 1) % _messages.length;
      });
      Future.delayed(const Duration(seconds: 3), _changeMessage);
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedLogo(
                        pulseAnimation: _pulseAnimation,
                        widget: widget,
                        rotationController: _rotationController),
                    const SizedBox(height: 60),
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.isLogout
                              ? Colors.orange.withValues(alpha: 0.8)
                              : Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        _messages[_messageIndex],
                        key: ValueKey<int>(_messageIndex),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.isLogout
                          ? 'Hasta pronto'
                          : 'Por favor espera un momento',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 60),
                    if (!widget.isLogout) const AdittionalInformationLogin(),
                    if (widget.isLogout) const AdittionalInformationLogout(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
