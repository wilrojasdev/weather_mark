// Vista de lista con historial
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_mark/features/weather/data/models/weather_model.dart';
import 'package:weather_mark/features/weather/presentation/bloc/weather/weather_bloc.dart';
import 'package:weather_mark/features/weather/presentation/bloc/weather/weather_event.dart';
import 'package:weather_mark/features/weather/presentation/helpers/map_state_helpers.dart';
import 'package:weather_mark/features/weather/presentation/pages/history/widgets/animated_card_weather.dart';
import 'package:weather_mark/features/weather/presentation/pages/history/widgets/delete_confirm_dialog.dart';

class HistoryListView extends StatelessWidget {
  final List<WeatherModel> weatherHistory;

  const HistoryListView({
    super.key,
    required this.weatherHistory,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.blue,
      backgroundColor: Colors.white,
      onRefresh: () async {
        context.read<WeatherBloc>().add(LoadWeatherHistory());
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 32),
        itemCount: weatherHistory.reversed.length,
        itemBuilder: (context, index) {
          final weather = weatherHistory.reversed.toList()[index];
          return AnimatedWeatherCard(
            weather: weather,
            index: index,
            onDelete: () => _showDeleteConfirmation(context, weather),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WeatherModel weather) {
    final weatherBloc = context.read<WeatherBloc>();

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (BuildContext dialogContext) {
        return DeleteConfirmationDialog(
          onConfirm: () {
            weatherBloc.add(
              DeleteWeather(weatherId: weather.id.toString()),
            );
            Navigator.of(dialogContext).pop();
            MapStateHelpers.showError(
                context, '¡Clima eliminado exitosamente!');
          },
        );
      },
    );
  }
}
