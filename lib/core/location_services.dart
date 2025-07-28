import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  static Future<bool> checkLocationPermission(BuildContext context,
      {VoidCallback? onDeniedForever}) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      final hasPermission = permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
      if (permission == LocationPermission.deniedForever &&
          onDeniedForever != null) {
        onDeniedForever();
      }
      return hasPermission;
    } catch (e) {
      debugPrint('Error checking location permission: $e');
      return false;
    }
  }

  static Future<LatLng?> getCurrentLocation(BuildContext context) async {
    try {
      final isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        throw Exception('El servicio de ubicación está deshabilitado');
      }
      final position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('Error obteniendo ubicación: $e');
      return null;
    }
  }
}
