// lib/features/weather/presentation/widgets/map/map_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_mark/features/weather/presentation/pages/map/widgets/map/map_marker_builder.dart';
import 'package:weather_mark/features/weather/presentation/pages/map/widgets/map/map_animation.dart';
import '../../../../bloc/weather/weather_state.dart';
import '../map_widget.dart';

import 'map_circle_builder.dart';

class MapController {
  final TickerProvider vsync;
  final VoidCallback onMarkersUpdated;

  late final MapAnimations _animations;
  late final MapMarkerBuilder _markerBuilder;
  late final MapCircleBuilder _circleBuilder;

  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  int _loadingAnimationFrame = 0;
  Timer? _loadingIconTimer;
  Timer? _animationTimer;
  bool _isMapReady = false;

  // Cache de la información actual para las animaciones
  LatLng? _currentLocation;
  LatLng? _tappedLocation;
  bool _hasPermission = false;
  WeatherState? _weatherState;
  VoidCallback? _onMarkerTap;

  Set<Marker> get markers => _markers;
  Set<Circle> get circles => _circles;

  MapController({
    required this.vsync,
    required this.onMarkersUpdated,
  }) {
    _animations = MapAnimations(vsync: vsync);
    _markerBuilder = MapMarkerBuilder();
    _circleBuilder = MapCircleBuilder();
  }

  void initialize() {
    _animations.init();
    _markerBuilder.preloadIcons();
    _startAnimationTimer();
  }

  void dispose() {
    _animations.dispose();
    _animationTimer?.cancel();
    _loadingIconTimer?.cancel();
  }

  void _startAnimationTimer() {
    _animationTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_isMapReady) {
        _updateAnimatedCircles();
      }
    });
  }

  void setMapReady(bool ready) {
    _isMapReady = ready;
  }

  void handleWidgetUpdate({
    required MapWidget widget,
    required MapWidget oldWidget,
    required WeatherState weatherState,
    GoogleMapController? googleMapController,
  }) {
    // Actualizar marcadores cuando cambian las ubicaciones
    if (widget.currentLocation != oldWidget.currentLocation ||
        widget.tappedLocation != oldWidget.tappedLocation ||
        widget.isLoadingWeather != oldWidget.isLoadingWeather) {
      updateMarkers(
        currentLocation: widget.currentLocation,
        tappedLocation: widget.tappedLocation,
        hasPermission: widget.hasPermission,
        weatherState: weatherState,
        onMarkerTap: widget.onMarkerTap,
      );
    }

    // Manejar animación de carga
    if (widget.isLoadingWeather && !oldWidget.isLoadingWeather) {
      _startLoadingAnimation(weatherState);
    } else if (!widget.isLoadingWeather && oldWidget.isLoadingWeather) {
      _stopLoadingAnimation();
    }

    // Centrar en nueva ubicación si cambió
    if (widget.tappedLocation != oldWidget.tappedLocation &&
        widget.tappedLocation != null &&
        googleMapController != null) {
      _animateCameraToLocation(googleMapController, widget.tappedLocation!);
    }
  }

  void _animateCameraToLocation(
      GoogleMapController controller, LatLng location) {
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 14,
          bearing: 0,
          tilt: 45,
        ),
      ),
    );
  }

  void _startLoadingAnimation(WeatherState weatherState) {
    if (weatherState is! WeatherLoading) return;

    _loadingAnimationFrame = 0;
    _loadingIconTimer?.cancel();
    _loadingIconTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (_weatherState is WeatherLoading) {
        _loadingAnimationFrame++;
        updateMarkers(
          currentLocation: _currentLocation,
          tappedLocation: _tappedLocation,
          hasPermission: _hasPermission,
          weatherState: _weatherState!,
          onMarkerTap: _onMarkerTap,
        );
      } else {
        _stopLoadingAnimation();
      }
    });
  }

  void _stopLoadingAnimation() {
    _loadingIconTimer?.cancel();
    _loadingAnimationFrame = 0;
  }

  void _updateAnimatedCircles() {
    if (!_isMapReady || _circles.isEmpty) return;

    final animatedCircles = _circleBuilder.updateAnimatedCircles(
      circles: _circles,
      pulseAnimation: _animations.pulseAnimation,
    );

    if (animatedCircles != _circles) {
      _circles = animatedCircles;
      onMarkersUpdated();
    }
  }

  Future<void> updateMarkers({
    required LatLng? currentLocation,
    required LatLng? tappedLocation,
    required bool hasPermission,
    required WeatherState weatherState,
    VoidCallback? onMarkerTap,
  }) async {
    // Guardar valores para las animaciones
    _currentLocation = currentLocation;
    _tappedLocation = tappedLocation;
    _hasPermission = hasPermission;
    _weatherState = weatherState;
    _onMarkerTap = onMarkerTap;

    final markers = <Marker>{};
    final circles = <Circle>{};

    // Marcador de ubicación actual
    if (currentLocation != null && hasPermission) {
      circles.add(_circleBuilder.createCurrentLocationCircle(currentLocation));

      final currentLocationIcon = _markerBuilder.currentLocationIcon;
      if (currentLocationIcon != null) {
        markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: currentLocation,
            icon: currentLocationIcon,
            anchor: const Offset(0.5, 0.5),
          ),
        );
      }
    }

    // Marcador del clima
    if (tappedLocation != null) {
      final isActuallyLoading = weatherState is WeatherLoading;

      // Círculo de selección
      final weatherCircle = _circleBuilder.createWeatherCircle(
        location: tappedLocation,
        isLoading: isActuallyLoading,
        weatherState: weatherState,
      );
      circles.add(weatherCircle);

      // Crear icono del marcador
      final weatherIcon = await _markerBuilder.createWeatherIcon(
        weatherState: weatherState,
        isLoading: isActuallyLoading,
        loadingFrame: _loadingAnimationFrame,
      );

      markers.add(
        Marker(
          markerId: const MarkerId('weather_location'),
          position: tappedLocation,
          icon: weatherIcon,
          anchor: const Offset(0.5, 0.95),
          onTap: onMarkerTap,
          infoWindow: InfoWindow(
            title: _getWeatherInfoTitle(weatherState, isActuallyLoading),
            snippet: _getWeatherInfoSnippet(weatherState),
          ),
        ),
      );
    }

    _markers = markers;
    _circles = circles;
    onMarkersUpdated();
  }

  String _getWeatherInfoTitle(WeatherState state, bool isLoading) {
    if (isLoading) return 'Consultando clima...';
    if (state is WeatherLoaded) {
      return '${state.weather.temperature.round()}°C - ${state.weather.name}';
    }
    return 'Toca para consultar';
  }

  String? _getWeatherInfoSnippet(WeatherState state) {
    if (state is WeatherLoaded) {
      return state.weather.description.toUpperCase();
    }
    return 'El clima en esta ubicación';
  }

  bool shouldShowWeatherLoading(bool isLoadingWeather, WeatherState state) {
    return isLoadingWeather && state is WeatherLoading;
  }
}
