import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_mark/features/weather/presentation/bloc/location/location_bloc.dart';
import 'package:weather_mark/features/weather/presentation/bloc/location/location_state.dart';
import 'package:weather_mark/features/weather/presentation/bloc/weather/weather_bloc.dart';
import 'package:weather_mark/features/weather/presentation/bloc/weather/weather_state.dart';
import 'package:weather_mark/features/weather/presentation/helpers/map_controller_helper.dart';
import 'package:weather_mark/features/weather/presentation/pages/map/widgets/location_loading_overlay.dart';
import 'package:weather_mark/features/weather/presentation/pages/map/widgets/map_widget.dart';

class MapContent extends StatelessWidget {
  final GoogleMapController? mapController;
  final Function(GoogleMapController) onMapCreated;
  final Function(LatLng) onMapTap;
  final VoidCallback onMarkerTap;
  final VoidCallback onMyLocationPressed;

  const MapContent({
    super.key,
    required this.mapController,
    required this.onMapCreated,
    required this.onMapTap,
    required this.onMarkerTap,
    required this.onMyLocationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      buildWhen: (previous, current) => true,
      builder: (context, locationState) {
        return BlocBuilder<WeatherBloc, WeatherState>(
          buildWhen: (previous, current) => true,
          builder: (context, weatherState) {
            return Stack(
              children: [
                MapWidget(
                  currentLocation: _getCurrentLocation(locationState),
                  tappedLocation: _getSelectedLocation(locationState),
                  hasPermission: _hasPermission(locationState),
                  isLoadingWeather: weatherState is WeatherLoading,
                  onMapTap: onMapTap,
                  onMarkerTap: onMarkerTap,
                  onMapCreated: onMapCreated,
                ),
                LocationLoadingOverlay(
                  isLoading: locationState is LocationLoading,
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: GoogleMapControls(
                    mapController: mapController,
                    visible: locationState is! LocationLoading,
                    onMyLocationPressed: onMyLocationPressed,
                    hasPermission: _hasPermission(locationState),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  LatLng? _getCurrentLocation(LocationState state) {
    if (state is LocationLoaded) {
      return state.currentLocation;
    } else if (state is LocationPermissionDenied) {
      return state.currentLocation;
    } else if (state is LocationError) {
      return state.currentLocation;
    }
    return null;
  }

  LatLng? _getSelectedLocation(LocationState state) {
    if (state is LocationLoaded) {
      return state.selectedLocation;
    } else if (state is LocationPermissionDenied) {
      return state.selectedLocation;
    }
    return null;
  }

  bool _hasPermission(LocationState state) {
    return state is LocationLoaded && state.hasPermission;
  }
}
