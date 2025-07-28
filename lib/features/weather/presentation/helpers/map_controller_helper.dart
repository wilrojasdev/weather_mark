// lib/features/weather/presentation/widgets/google_map_controls.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

class GoogleMapControls extends StatefulWidget {
  final GoogleMapController? mapController;
  final bool visible;
  final VoidCallback onMyLocationPressed;
  final bool hasPermission;

  const GoogleMapControls({
    super.key,
    required this.mapController,
    required this.visible,
    required this.onMyLocationPressed,
    required this.hasPermission,
  });

  @override
  State<GoogleMapControls> createState() => _GoogleMapControlsState();
}

class _GoogleMapControlsState extends State<GoogleMapControls>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  double _currentZoom = 15.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    if (widget.visible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(GoogleMapControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _zoomIn() async {
    if (widget.mapController != null) {
      _currentZoom = await widget.mapController!.getZoomLevel();
      widget.mapController!.animateCamera(
        CameraUpdate.zoomTo(math.min(_currentZoom + 1, 20)),
      );
    }
  }

  Future<void> _zoomOut() async {
    if (widget.mapController != null) {
      _currentZoom = await widget.mapController!.getZoomLevel();
      widget.mapController!.animateCamera(
        CameraUpdate.zoomTo(math.max(_currentZoom - 1, 5)),
      );
    }
  }

  Future<void> _resetBearing() async {
    if (widget.mapController != null) {
      widget.mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: await _getCurrentTarget(),
            zoom: _currentZoom,
            bearing: 0,
            tilt: 0,
          ),
        ),
      );
    }
  }

  Future<LatLng> _getCurrentTarget() async {
    if (widget.mapController != null) {
      final LatLngBounds bounds =
          await widget.mapController!.getVisibleRegion();
      return LatLng(
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
      );
    }
    return const LatLng(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 40,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.hasPermission)
                _MapControlButton(
                  icon: Icons.my_location,
                  onPressed: widget.onMyLocationPressed,
                  tooltip: 'Mi ubicación',
                  heroTag: 'my_location',
                ),
              const SizedBox(height: 8),

              // Controles de zoom
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3C72).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MapControlButton(
                      icon: Icons.add,
                      onPressed: _zoomIn,
                      tooltip: 'Acercar',
                      heroTag: 'zoom_in',
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    Container(
                      height: 1,
                      width: 40,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    _MapControlButton(
                      icon: Icons.remove,
                      onPressed: _zoomOut,
                      tooltip: 'Alejar',
                      heroTag: 'zoom_out',
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Botón de brújula
              _MapControlButton(
                icon: Icons.explore,
                onPressed: _resetBearing,
                tooltip: 'Restablecer orientación',
                heroTag: 'compass',
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapControlButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final String heroTag;
  final BorderRadius? borderRadius;

  const _MapControlButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    required this.heroTag,
    this.borderRadius,
  });

  @override
  State<_MapControlButton> createState() => _MapControlButtonState();
}

class _MapControlButtonState extends State<_MapControlButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF203A43).withValues(alpha: 0.9),
                const Color(0xFF2C5364).withValues(alpha: 0.9),
              ],
            ),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _isPressed
                    ? Colors.black.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.2),
                blurRadius: _isPressed ? 5 : 10,
                offset: Offset(0, _isPressed ? 2 : 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
              child: Center(
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
