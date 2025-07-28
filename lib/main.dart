// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_mark/features/auth/presentation/bloc/auth_event.dart';
import 'package:weather_mark/features/weather/presentation/bloc/location/location_bloc.dart';
import 'package:weather_mark/features/weather/presentation/bloc/weather/weather_bloc.dart';
import 'package:weather_mark/splash_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'injection_container.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 253, 253, 253),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthBloc>()..add(CheckAuthStatus()),
        ),
        BlocProvider(
          create: (_) => sl<WeatherBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<LocationBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const SplashPage(),
      ),
    );
  }
}
