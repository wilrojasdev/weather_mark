// lib/features/weather/presentation/pages/map_page.dart (sin anidamiento)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_mark/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:weather_mark/features/auth/presentation/bloc/auth_event.dart';
import 'package:weather_mark/features/auth/presentation/bloc/auth_state.dart';
import 'package:weather_mark/features/weather/domain/entities/weather.dart';
import 'package:weather_mark/features/weather/presentation/bloc/location/location_bloc.dart';
import 'package:weather_mark/features/weather/presentation/bloc/location/location_event.dart';
import 'package:weather_mark/features/weather/presentation/bloc/location/location_state.dart';
import 'package:weather_mark/features/weather/presentation/bloc/weather/weather_bloc.dart';
import 'package:weather_mark/features/weather/presentation/bloc/weather/weather_event.dart';
import 'package:weather_mark/features/weather/presentation/bloc/weather/weather_state.dart';
import 'package:weather_mark/features/weather/presentation/pages/map/widgets/appbar_custom.dart';
import 'package:weather_mark/features/weather/presentation/pages/map/widgets/logout_dialog.dart';
import 'package:weather_mark/features/weather/presentation/pages/map/widgets/map_content.dart';
import 'package:weather_mark/features/weather/presentation/pages/map/widgets/weather_info_overlay.dart';
import '../../helpers/map_state_helpers.dart';
import '../history/history_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with WidgetsBindingObserver {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationBloc>().add(
            CheckLocationPermission(context: context),
          );
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mapController?.dispose();
    super.dispose();
  }

  void _handleMapTap(LatLng point) {
    context.read<LocationBloc>().add(
          UpdateSelectedLocation(location: point),
        );
    context.read<WeatherBloc>().add(
          LoadWeatherForLocation(
            latitude: point.latitude,
            longitude: point.longitude,
          ),
        );
  }

  void _handleMyLocationPressed() {
    context.read<LocationBloc>().add(
          RequestCurrentLocation(context: context),
        );
  }

  void _showWeatherBottomSheet() {
    final currentWeatherState = context.read<WeatherBloc>().state;
    Weather? currentWeather;
    if (currentWeatherState is WeatherLoaded) {
      currentWeather = currentWeatherState.weather;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, weatherState) {
          Weather? weatherToShow;
          bool isLoading = false;
          bool isSaving = false;

          if (weatherState is WeatherLoading) {
            isLoading = true;
            weatherToShow = currentWeather;
          } else if (weatherState is WeatherLoaded) {
            weatherToShow = weatherState.weather;
          } else if (weatherState is WeatherSaving) {
            weatherToShow = weatherState.weather;
            isSaving = true;
          } else if (weatherState is WeatherSaved) {
            weatherToShow = weatherState.weather;
          } else {
            weatherToShow = currentWeather;
          }
          return WeatherInfoOverlay(
            weather: weatherToShow,
            isLoading: isLoading,
            onSave: isSaving || weatherToShow?.savedAt != null
                ? null
                : () {
                    context.read<WeatherBloc>().add(
                          SaveCurrentWeather(weather: weatherToShow!),
                        );

                    Navigator.pop(context);
                  },
            onClose: () => Navigator.pop(modalContext),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: WeatherAppBar(
        onHistoryPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HistoryPage()),
        ),
        onLogoutPressed: () => showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return LogoutDialog(
              onConfirm: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
            );
          },
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Unauthenticated) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
          BlocListener<LocationBloc, LocationState>(
            listener: (context, state) {
              if (state is LocationLoaded) {
                _mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: state.selectedLocation,
                      zoom: 16,
                      tilt: 45,
                    ),
                  ),
                );
                context.read<WeatherBloc>().add(
                      LoadWeatherForLocation(
                        latitude: state.selectedLocation.latitude,
                        longitude: state.selectedLocation.longitude,
                      ),
                    );
              } else if (state is LocationError) {
                MapStateHelpers.showWarning(
                  context,
                  state.message,
                  onRetry: _handleMyLocationPressed,
                );
              }
            },
          ),
          BlocListener<WeatherBloc, WeatherState>(
            listener: (context, state) {
              if (state is WeatherLoaded) {
                _showWeatherBottomSheet();
              } else if (state is WeatherSaved) {
                MapStateHelpers.showSuccess(
                  context,
                  '¡Clima guardado exitosamente!',
                );
              } else if (state is WeatherError) {
                MapStateHelpers.showError(
                  context,
                  state.message,
                  onRetry: () {
                    final locationState = context.read<LocationBloc>().state;
                    if (locationState is LocationLoaded) {
                      context.read<WeatherBloc>().add(
                            LoadWeatherForLocation(
                              latitude: locationState.selectedLocation.latitude,
                              longitude:
                                  locationState.selectedLocation.longitude,
                            ),
                          );
                    }
                  },
                );
              }
            },
          ),
        ],
        child: MapContent(
          mapController: _mapController,
          onMapCreated: (controller) {
            setState(() {
              _mapController = controller;
            });
          },
          onMapTap: _handleMapTap,
          onMarkerTap: () {
            final weatherState = context.read<WeatherBloc>().state;
            if (weatherState is! WeatherLoading) {
              _showWeatherBottomSheet();
            }
          },
          onMyLocationPressed: _handleMyLocationPressed,
        ),
      ),
    );
  }
}
