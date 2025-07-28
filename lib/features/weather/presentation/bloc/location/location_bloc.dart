// lib/features/location/presentation/bloc/location_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_mark/core/location_services.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  static const LatLng defaultLocation = LatLng(4.7110, -74.0721);

  LocationBloc() : super(LocationInitial()) {
    on<CheckLocationPermission>(_onCheckLocationPermission);
    on<RequestCurrentLocation>(_onRequestCurrentLocation);
    on<UpdateSelectedLocation>(_onUpdateSelectedLocation);
  }

  Future<void> _onCheckLocationPermission(
    CheckLocationPermission event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());

    try {
      final hasPermission = await LocationService.checkLocationPermission(
        event.context,
      );

      if (hasPermission) {
        emit(LocationPermissionGranted());

        // ignore: use_build_context_synchronously
        add(RequestCurrentLocation(context: event.context));
      } else {
        emit(LocationPermissionDenied(
          currentLocation: defaultLocation,
          selectedLocation: defaultLocation,
        ));
      }
    } catch (e) {
      emit(LocationError(
        message: 'Error verificando permisos',
        currentLocation: defaultLocation,
      ));
    }
  }

  Future<void> _onRequestCurrentLocation(
    RequestCurrentLocation event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());

    try {
      final location = await LocationService.getCurrentLocation(event.context);

      if (location != null) {
        emit(LocationLoaded(
          currentLocation: location,
          selectedLocation: location,
          hasPermission: true,
        ));
      } else {
        emit(LocationError(
          message: 'No se pudo obtener la ubicación',
          currentLocation: state is LocationLoaded
              ? (state as LocationLoaded).currentLocation
              : defaultLocation,
        ));
      }
    } catch (e) {
      emit(LocationError(
        message: 'Error obteniendo ubicación: ${e.toString()}',
        currentLocation: defaultLocation,
      ));
    }
  }

  void _onUpdateSelectedLocation(
    UpdateSelectedLocation event,
    Emitter<LocationState> emit,
  ) {
    if (state is LocationLoaded) {
      emit((state as LocationLoaded).copyWith(
        selectedLocation: event.location,
      ));
    } else {
      // Si no hay estado previo, crear uno nuevo
      emit(LocationLoaded(
        currentLocation: defaultLocation,
        selectedLocation: event.location,
        hasPermission: false,
      ));
    }
  }
}
