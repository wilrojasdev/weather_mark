// lib/features/weather/presentation/widgets/map/map_marker_builder.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../bloc/weather/weather_state.dart';
import 'map_icon_painter.dart';

class MapMarkerBuilder {
  BitmapDescriptor? _currentLocationIcon;
  final Map<String, BitmapDescriptor> _weatherIconCache = {};
  final MapIconPainter _iconPainter = MapIconPainter();

  BitmapDescriptor? get currentLocationIcon => _currentLocationIcon;

  Future<void> preloadIcons() async {
    _currentLocationIcon = await _iconPainter.createCurrentLocationIcon();
  }

  Future<BitmapDescriptor> createWeatherIcon({
    required WeatherState weatherState,
    required bool isLoading,
    required int loadingFrame,
  }) async {
    if (isLoading) {
      return await _iconPainter.createAnimatedLoadingIcon(loadingFrame);
    }

    if (weatherState is WeatherLoaded) {
      final weather = weatherState.weather;
      final iconKey =
          '${weather.temperature.round()}_${weather.icon}_${weather.description}';

      if (!_weatherIconCache.containsKey(iconKey)) {
        _weatherIconCache[iconKey] = await _iconPainter.createWeatherMarkerIcon(
          temperature: weather.temperature,
          iconCode: weather.icon,
          description: weather.description,
        );
      }
      return _weatherIconCache[iconKey]!;
    }

    return await _iconPainter.createDefaultMarkerIcon();
  }
}
