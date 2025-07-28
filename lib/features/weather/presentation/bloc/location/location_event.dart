// location_event.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationEvent {}

class CheckLocationPermission extends LocationEvent {
  final BuildContext context;
  CheckLocationPermission({required this.context});
}

class RequestCurrentLocation extends LocationEvent {
  final BuildContext context;
  RequestCurrentLocation({required this.context});
}

class UpdateSelectedLocation extends LocationEvent {
  final LatLng location;
  UpdateSelectedLocation({required this.location});
}

class ClearLocationData extends LocationEvent {}
