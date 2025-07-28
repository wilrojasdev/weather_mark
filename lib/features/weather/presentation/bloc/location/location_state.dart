// location_state.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationPermissionGranted extends LocationState {}

class LocationPermissionDenied extends LocationState {
  final LatLng currentLocation;
  final LatLng selectedLocation;

  LocationPermissionDenied({
    required this.currentLocation,
    required this.selectedLocation,
  });
}

class LocationLoaded extends LocationState {
  final LatLng currentLocation;
  final LatLng selectedLocation;
  final bool hasPermission;

  LocationLoaded({
    required this.currentLocation,
    required this.selectedLocation,
    required this.hasPermission,
  });

  LocationLoaded copyWith({
    LatLng? currentLocation,
    LatLng? selectedLocation,
    bool? hasPermission,
  }) {
    return LocationLoaded(
      currentLocation: currentLocation ?? this.currentLocation,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      hasPermission: hasPermission ?? this.hasPermission,
    );
  }
}

class LocationError extends LocationState {
  final String message;
  final LatLng currentLocation;

  LocationError({
    required this.message,
    required this.currentLocation,
  });
}
