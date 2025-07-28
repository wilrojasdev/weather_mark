// splash_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_mark/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:weather_mark/features/auth/presentation/bloc/auth_state.dart';
import 'package:weather_mark/features/auth/presentation/pages/login_page.dart';
import 'package:weather_mark/features/auth/presentation/pages/loading_page.dart';
import 'package:weather_mark/features/weather/presentation/bloc/location/location_bloc.dart';
import 'package:weather_mark/features/weather/presentation/bloc/location/location_event.dart';
import 'package:weather_mark/features/weather/presentation/pages/map/map_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with WidgetsBindingObserver {
  bool _isAuth0ProcessActive = false;
  bool _isLogoutProcess = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Manejar el proceso de Auth0
        if (state is! AuthLoading && _isAuth0ProcessActive) {
          setState(() {
            _isAuth0ProcessActive = false;
            _isLogoutProcess = false;
          });
        }

        // Limpiar datos de otros blocs cuando el usuario se desautentica
        if (state is Unauthenticated) {
          _clearUserData(context);
        }
      },
      builder: (context, state) {
        // Determinar si es un proceso de logout
        bool isLogout = false;
        if (state is AuthLoading) {
          isLogout = state.isLogout;
        } else if (_isAuth0ProcessActive) {
          isLogout = _isLogoutProcess;
        }

        // Mostrar página de carga durante el proceso de Auth0
        if (_isAuth0ProcessActive || state is AuthLoading) {
          return LoadingPage(
            isLogout: isLogout,
          );
        }

        // Usuario autenticado - mostrar MapPage
        if (state is Authenticated) {
          return const MapPage();
        }

        // Usuario no autenticado o error - mostrar LoginPage
        if (state is Unauthenticated || state is AuthError) {
          return const LoginPage();
        }

        // Estado inicial - mostrar splash screen
        return const _SplashScreen();
      },
    );
  }

  // Método para limpiar datos de usuario de todos los blocs
  void _clearUserData(BuildContext context) {
    // Limpiar datos del WeatherBloc

    // Limpiar datos del LocationBloc si existe
    try {
      context.read<LocationBloc>().add(ClearLocationData());
    } catch (e) {
      // LocationBloc podría no estar disponible
    }

    // Agregar aquí la limpieza de otros blocs si es necesario
  }
}

// Widget separado para la pantalla de splash
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0F2027),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
