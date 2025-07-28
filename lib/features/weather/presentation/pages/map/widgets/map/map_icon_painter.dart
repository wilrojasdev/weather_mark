// lib/features/weather/presentation/widgets/map/map_icon_painter.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'map_utils.dart';

class MapIconPainter {
  Future<BitmapDescriptor> createCurrentLocationIcon() async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    const size = 60.0;

    // Dibujar círculo exterior
    final outerPaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, outerPaint);

    // Dibujar círculo medio
    final middlePaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 3, middlePaint);

    // Dibujar círculo interior
    final innerPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 6, innerPaint);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    // ignore: deprecated_member_use
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> createAnimatedLoadingIcon(int frame) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    const size = 140.0;
    const pinHeight = 40.0;

    // Calcular rotación basada en el frame
    final rotation = (frame * 0.1) % (2 * math.pi);

    // Pin del marcador
    _drawMapPin(canvas, size, Colors.blue.shade600);

    // Fondo del círculo
    _drawCircleBackground(canvas, size);

    // Borde del círculo
    final borderPaint = Paint()
      ..color = Colors.blue.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(
        const Offset(size / 2, size / 2), size / 2.8, borderPaint);

    // Arcos de carga animados
    _drawLoadingArcs(canvas, size, rotation);

    final picture = pictureRecorder.endRecording();
    final image =
        await picture.toImage(size.toInt(), size.toInt() + pinHeight.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    // ignore: deprecated_member_use
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> createWeatherMarkerIcon({
    required double temperature,
    required String iconCode,
    required String description,
  }) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    const size = 140.0;
    const pinHeight = 40.0;

    // Obtener color según el tipo de clima
    final color = MapUtils.getWeatherColor(iconCode);

    // Pin del marcador
    _drawMapPin(canvas, size, color);

    // Fondo del marcador
    _drawCircleBackground(canvas, size);

    // Borde
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(
        const Offset(size / 2, size / 2), size / 2.8, borderPaint);

    // Cargar y dibujar el icono del clima
    await _drawWeatherIcon(canvas, size, iconCode, color);

    // Dibujar temperatura
    _drawTemperature(canvas, size, temperature, color);

    final picture = pictureRecorder.endRecording();
    final image =
        await picture.toImage(size.toInt(), size.toInt() + pinHeight.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    // ignore: deprecated_member_use
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> createDefaultMarkerIcon() async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    const size = 100.0;

    // Fondo gris para estado por defecto
    final bgPaint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2.5, bgPaint);

    // Icono de ubicación
    final iconPainter = TextPainter(
      text: const TextSpan(
        text: '📍',
        style: TextStyle(fontSize: 30),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(
        (size - iconPainter.width) / 2,
        (size - iconPainter.height) / 2,
      ),
    );

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    // ignore: deprecated_member_use
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  void _drawMapPin(Canvas canvas, double size, Color color) {
    final pinPath = Path();
    pinPath.moveTo(size / 2, size - 10);
    pinPath.lineTo(size / 2 - 15, size - 25);
    pinPath.arcToPoint(
      Offset(size / 2 + 15, size - 25),
      radius: const Radius.circular(15),
      clockwise: true,
    );
    pinPath.close();

    final pinPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(pinPath, pinPaint);
  }

  void _drawCircleBackground(Canvas canvas, double size) {
    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawCircle(Offset(size / 2, size / 2 + 5), size / 2.8, shadowPaint);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, bgPaint);
  }

  void _drawLoadingArcs(Canvas canvas, double size, double rotation) {
    canvas.save();
    canvas.translate(size / 2, size / 2);
    canvas.rotate(rotation);

    final loadingPaint = Paint()
      ..color = Colors.blue.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    const sweepAngle = math.pi / 2;
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: size / 4),
      0,
      sweepAngle,
      false,
      loadingPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: size / 4),
      math.pi,
      sweepAngle,
      false,
      loadingPaint,
    );

    canvas.restore();
  }

  Future<void> _drawWeatherIcon(
    Canvas canvas,
    double size,
    String iconCode,
    Color color,
  ) async {
    try {
      final imageUrl = 'https://openweathermap.org/img/wn/$iconCode@4x.png';
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final Uint8List imageBytes = response.bodyBytes;
        final ui.Codec codec = await ui.instantiateImageCodec(
          imageBytes,
          targetWidth: 60,
          targetHeight: 60,
        );
        final ui.FrameInfo frameInfo = await codec.getNextFrame();
        final ui.Image image = frameInfo.image;

        canvas.drawImage(
          image,
          Offset(size / 2 - 30, size / 2 - 40),
          Paint(),
        );
      }
    } catch (e) {
      // Si falla, dibujar un icono de nube por defecto
      _drawDefaultCloudIcon(canvas, size, color);
    }
  }

  void _drawDefaultCloudIcon(Canvas canvas, double size, Color color) {
    final iconPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size / 2 - 10, size / 2 - 10), 12, iconPaint);
    canvas.drawCircle(Offset(size / 2 + 10, size / 2 - 10), 12, iconPaint);
    canvas.drawCircle(Offset(size / 2, size / 2 - 20), 15, iconPaint);
  }

  void _drawTemperature(
      Canvas canvas, double size, double temperature, Color color) {
    final tempPainter = TextPainter(
      text: TextSpan(
        text: '${temperature.round()}°',
        style: TextStyle(
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    tempPainter.layout();
    tempPainter.paint(
      canvas,
      Offset(
        (size - tempPainter.width) / 2,
        size / 2 + 15,
      ),
    );
  }
}
