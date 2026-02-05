import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Generates a pin-shaped pet marker icon for Google Maps.
///
/// The marker has a circular head (with pet image or emoji) and a pointed
/// bottom, like the default Google Maps pin. The tip aligns with the
/// Marker's default anchor (0.5, 1.0).
Future<BitmapDescriptor> generatePetMarkerIcon({
  required Uint8List? imageBytes,
  required String fallbackText,
  required Color borderColor,
  double outerRadius = 48,
  double borderWidth = 5,
  double pointerHeight = 24,
}) async {
  final gapWidth = borderWidth * 0.6;
  final innerRadius = outerRadius - borderWidth - gapWidth;

  final canvasWidth = outerRadius * 2;
  final canvasHeight = outerRadius * 2 + pointerHeight;

  final cx = canvasWidth / 2;
  final cy = outerRadius;
  final tipY = canvasHeight;

  final halfAngle = 35 * math.pi / 180;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  // 1. Drop shadow
  final shadowPath =
      _buildPinPath(cx, cy + 2, outerRadius, halfAngle, cx, tipY + 2);
  canvas.drawPath(
    shadowPath,
    Paint()
      ..color = const Color(0x40000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
  );

  // 2. Pin body (border color)
  final pinPath = _buildPinPath(cx, cy, outerRadius, halfAngle, cx, tipY);
  canvas.drawPath(pinPath, Paint()..color = borderColor);

  // 3. White gap circle
  canvas.drawCircle(
    Offset(cx, cy),
    outerRadius - borderWidth,
    Paint()..color = Colors.white,
  );

  // 4. Inner content (image or emoji fallback)
  final center = Offset(cx, cy);

  if (imageBytes != null) {
    final codec = await ui.instantiateImageCodec(
      imageBytes,
      targetWidth: (innerRadius * 2).toInt(),
      targetHeight: (innerRadius * 2).toInt(),
    );
    final frame = await codec.getNextFrame();
    final image = frame.image;

    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: innerRadius)),
    );
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromCircle(center: center, radius: innerRadius),
      Paint(),
    );
    canvas.restore();
    image.dispose();
  } else {
    canvas.drawCircle(center, innerRadius, Paint()..color = Colors.grey.shade200);

    final tp = TextPainter(
      text: TextSpan(
        text: fallbackText,
        style: TextStyle(fontSize: innerRadius * 0.9),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  // Convert to BitmapDescriptor
  final picture = recorder.endRecording();
  final img = await picture.toImage(canvasWidth.toInt(), canvasHeight.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  img.dispose();

  if (byteData == null) {
    return BitmapDescriptor.defaultMarker;
  }

  return BitmapDescriptor.bytes(
    byteData.buffer.asUint8List(),
    width: 40,
  );
}

/// Builds a pin-shaped [Path]: circle arc at the top with a triangular
/// pointer extending to [tipY] at the bottom.
Path _buildPinPath(
  double cx,
  double cy,
  double radius,
  double halfAngle,
  double tipX,
  double tipY,
) {
  final startAngle = math.pi / 2 + halfAngle;
  final sweepAngle = 2 * math.pi - 2 * halfAngle;

  return Path()
    ..arcTo(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      startAngle,
      sweepAngle,
      true,
    )
    ..lineTo(tipX, tipY)
    ..close();
}
