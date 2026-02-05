import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/models/route_point.dart';

enum SpeedCategory { stationary, walking, jogging, running }

SpeedCategory categorizeSpeed(double speedMps) {
  if (speedMps < AppConstants.speedThresholdStationary) {
    return SpeedCategory.stationary;
  } else if (speedMps < AppConstants.speedThresholdWalking) {
    return SpeedCategory.walking;
  } else if (speedMps < AppConstants.speedThresholdJogging) {
    return SpeedCategory.jogging;
  } else {
    return SpeedCategory.running;
  }
}

Color speedCategoryColor(SpeedCategory category) {
  switch (category) {
    case SpeedCategory.stationary:
      return Colors.blue;
    case SpeedCategory.walking:
      return Colors.green;
    case SpeedCategory.jogging:
      return Colors.yellow.shade700;
    case SpeedCategory.running:
      return Colors.red;
  }
}

/// Convert a list of RoutePoints into a set of speed-colored Polylines.
/// Consecutive points with the same SpeedCategory are batched into one Polyline.
/// Boundary points are included in both adjacent Polylines to prevent gaps.
Set<Polyline> buildSpeedPolylines(List<RoutePoint> points) {
  if (points.length < 2) return {};

  final polylines = <Polyline>{};
  int segmentIndex = 0;

  var currentCategory = categorizeSpeed(points[0].speedMps);
  var currentPoints = <LatLng>[
    LatLng(points[0].location.latitude, points[0].location.longitude),
  ];

  for (int i = 1; i < points.length; i++) {
    final category = categorizeSpeed(points[i].speedMps);
    final latLng = LatLng(
      points[i].location.latitude,
      points[i].location.longitude,
    );

    if (category == currentCategory) {
      currentPoints.add(latLng);
    } else {
      // Include boundary point in the current segment
      currentPoints.add(latLng);

      polylines.add(Polyline(
        polylineId: PolylineId('route_$segmentIndex'),
        points: List.of(currentPoints),
        color: speedCategoryColor(currentCategory),
        width: 4,
      ));

      segmentIndex++;
      currentCategory = category;
      // Start new segment from boundary point
      currentPoints = [latLng];
    }
  }

  // Flush remaining segment
  if (currentPoints.length >= 2) {
    polylines.add(Polyline(
      polylineId: PolylineId('route_$segmentIndex'),
      points: List.of(currentPoints),
      color: speedCategoryColor(currentCategory),
      width: 4,
    ));
  }

  return polylines;
}
