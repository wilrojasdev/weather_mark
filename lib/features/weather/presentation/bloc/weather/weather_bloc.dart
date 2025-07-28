// lib/features/weather/presentation/bloc/weather_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_mark/core/usecase/usecase.dart';
import 'package:weather_mark/features/weather/domain/usecases/delete_weather_record.dart';
import '../../../domain/usecases/get_saved_weather_history.dart';
import '../../../domain/usecases/get_weather_by_location.dart';
import '../../../domain/usecases/save_weather.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherByLocation getWeatherByLocation;
  final SaveWeather saveWeather;
  final GetSavedWeatherHistory getSavedWeatherHistory;
  final DeleteWeatherRecord deleteWeatherRecord;
  WeatherBloc(
      {required this.getWeatherByLocation,
      required this.saveWeather,
      required this.getSavedWeatherHistory,
      required this.deleteWeatherRecord})
      : super(WeatherLoading()) {
    on<LoadWeatherForLocation>(_onLoadWeatherForLocation);
    on<SaveCurrentWeather>(_onSaveCurrentWeather);
    on<LoadWeatherHistory>(_onLoadWeatherHistory);
    on<DeleteWeather>(_onDeleteWeatherRecord);
  }

  Future<void> _onLoadWeatherForLocation(
    LoadWeatherForLocation event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    final result = await getWeatherByLocation(
      LocationParams(
        latitude: event.latitude,
        longitude: event.longitude,
      ),
    );
    result.fold(
      (failure) => emit(const WeatherError(message: 'Failed to load weather')),
      (weather) => emit(WeatherLoaded(weather: weather)),
    );
  }

// En weather_bloc.dart, corrige el método _onSaveCurrentWeather:
  Future<void> _onSaveCurrentWeather(
    SaveCurrentWeather event,
    Emitter<WeatherState> emit,
  ) async {
    // Emitir estado de guardado CON el weather
    emit(WeatherSaving(weather: event.weather));

    final result = await saveWeather(
      SaveWeatherParams(weather: event.weather),
    );

    await result.fold(
      (failure) async {
        emit(const WeatherError(
          message: 'No se pudo guardar el clima',
        ));
      },
      (_) async {
        // Actualizar el weather con la fecha de guardado
        final savedWeather = event.weather.copyWith(
          savedAt: DateTime.now(),
        );

        emit(WeatherSaved(weather: savedWeather));

        // IMPORTANTE: Usar await aquí
        await Future.delayed(const Duration(milliseconds: 100));

        // Verificar que el emit sea seguro
        if (!emit.isDone) {
          emit(WeatherLoaded(weather: savedWeather));
        }
      },
    );
  }

  Future<void> _onLoadWeatherHistory(
    LoadWeatherHistory event,
    Emitter<WeatherState> emit,
  ) async {
    final result = await getSavedWeatherHistory(NoParams());
    result.fold(
      (failure) => emit(const WeatherError(message: 'Failed to load history')),
      (weatherList) => emit(WeatherHistoryLoaded(weatherHistory: weatherList)),
    );
  }

  Future<void> _onDeleteWeatherRecord(
    DeleteWeather event,
    Emitter<WeatherState> emit,
  ) async {
    final result = await deleteWeatherRecord(
      WeatherIdParams(id: event.weatherId),
    );
    result.fold(
      (failure) =>
          emit(const WeatherError(message: 'Failed to delete weather record')),
      (_) => add(LoadWeatherHistory()),
    );
  }
}
