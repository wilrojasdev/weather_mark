import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_mark/features/weather/presentation/bloc/weather/weather_event.dart';
import 'package:weather_mark/features/weather/presentation/pages/history/widgets/empty_weather.dart';
import 'package:weather_mark/features/weather/presentation/pages/history/widgets/error_weather.dart';
import 'package:weather_mark/features/weather/presentation/pages/history/widgets/history_appbar.dart';
import 'package:weather_mark/features/weather/presentation/pages/history/widgets/history_listview.dart';
import 'package:weather_mark/features/weather/presentation/pages/history/widgets/loading_weather.dart';
import '../../../../../injection_container.dart';
import '../../bloc/weather/weather_bloc.dart';
import '../../bloc/weather/weather_state.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WeatherBloc>()..add(LoadWeatherHistory()),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0E21),
        extendBodyBehindAppBar: true,
        appBar: const HistoryAppBar(),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 30, 65, 80),
                Color.fromARGB(255, 44, 88, 103),
                Color.fromARGB(255, 51, 102, 124),
              ],
            ),
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return const LoadingWeather();
                  }
                  if (state is WeatherError) {
                    return ErrorWeather(
                      message: state.message,
                      onRetry: () {
                        context.read<WeatherBloc>().add(LoadWeatherHistory());
                      },
                    );
                  }
                  if (state is WeatherHistoryLoaded) {
                    if (state.weatherHistory.isEmpty) {
                      return const EmptyWeather();
                    }
                    return HistoryListView(
                      weatherHistory: state.weatherHistory,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
