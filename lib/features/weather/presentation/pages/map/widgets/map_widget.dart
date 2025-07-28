// lib/features/weather/presentation/widgets/map_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../bloc/weather/weather_bloc.dart';
import '../../../bloc/weather/weather_state.dart';
import 'map/map_controller.dart';

import 'map/map_weather_loading_indicator.dart';

class MapWidget extends StatefulWidget {
  final LatLng? currentLocation;
  final LatLng? tappedLocation;
  final bool hasPermission;
  final bool isLoadingWeather;
  final Function(LatLng) onMapTap;
  final VoidCallback onMarkerTap;
  final Function(GoogleMapController) onMapCreated;

  const MapWidget({
    super.key,
    required this.currentLocation,
    required this.tappedLocation,
    required this.hasPermission,
    required this.isLoadingWeather,
    required this.onMapTap,
    required this.onMarkerTap,
    required this.onMapCreated,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  late MapController _mapController;
  GoogleMapController? _googleMapController;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController(
      vsync: this,
      onMarkersUpdated: () {
        if (mounted) setState(() {});
      },
    );
    _mapController.initialize();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _googleMapController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Delegar la actualización al controlador
    _mapController.handleWidgetUpdate(
      widget: widget,
      oldWidget: oldWidget,
      weatherState: context.read<WeatherBloc>().state,
      googleMapController: _googleMapController,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
    widget.onMapCreated(controller);

    setState(() {
      _isMapReady = true;
    });

    // Actualizar marcadores iniciales
    _mapController.updateMarkers(
      currentLocation: widget.currentLocation,
      tappedLocation: widget.tappedLocation,
      hasPermission: widget.hasPermission,
      weatherState: context.read<WeatherBloc>().state,
      onMarkerTap: widget.onMarkerTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherBloc, WeatherState>(
      listener: (context, state) {
        // Actualizar marcadores cuando cambia el estado del clima
        _mapController.updateMarkers(
          currentLocation: widget.currentLocation,
          tappedLocation: widget.tappedLocation,
          hasPermission: widget.hasPermission,
          weatherState: state,
          onMarkerTap: widget.onMarkerTap,
        );
      },
      child: Stack(
        children: [
          // Mapa principal
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: widget.currentLocation ?? const LatLng(4.1533, -73.6376),
              zoom: 14,
              tilt: 45,
            ),
            onTap: widget.onMapTap,
            markers: _mapController.markers,
            circles: _mapController.circles,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: true,
            tiltGesturesEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            buildingsEnabled: true,
            trafficEnabled: false,
            indoorViewEnabled: false,
            mapType: MapType.normal,
            padding: const EdgeInsets.only(top: 100),
          ),

          // Indicador de carga del mapa
          if (!_isMapReady) const MapLoadingIndicator(),

          // Indicador de carga del clima
          if (_mapController.shouldShowWeatherLoading(
            widget.isLoadingWeather,
            context.read<WeatherBloc>().state,
          ))
            const MapWeatherLoadingIndicator(),
        ],
      ),
    );
  }
}
