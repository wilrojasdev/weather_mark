import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_mark/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:weather_mark/features/auth/presentation/bloc/auth_state.dart';
import 'package:weather_mark/features/weather/presentation/pages/map/widgets/appbar_animated_pattern.dart';
import 'package:weather_mark/features/weather/presentation/pages/map/widgets/glowing_icon_button.dart';

class WeatherAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onHistoryPressed;
  final VoidCallback onLogoutPressed;
  final String? locationName;
  final double? temperature;
  final String? weatherIcon;

  const WeatherAppBar({
    super.key,
    required this.onHistoryPressed,
    required this.onLogoutPressed,
    this.locationName,
    this.temperature,
    this.weatherIcon,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          String userName = 'Usuario';
          String userEmail = 'userEmail';

          if (authState is Authenticated) {
            userName = authState.user.name;
            userEmail = authState.user.email;
          }

          return Container(
            height: preferredSize.height + MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                const AnimatedPattern(),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 1.2,
                                        shadows: [
                                          Shadow(
                                            color: Colors.blue
                                                .withValues(alpha: 0.5),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      userEmail,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color:
                                            Colors.white.withValues(alpha: 0.7),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GlowingIconButton(
                                  icon: Icons.history_rounded,
                                  onPressed: onHistoryPressed,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(width: 8),
                                GlowingIconButton(
                                  icon: Icons.power_settings_new_rounded,
                                  onPressed: onLogoutPressed,
                                  color: Colors.redAccent,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
