import 'dart:math';

import '../../core/constants/app_constants.dart';
import '../../domain/models/route_point.dart';
import '../models/location.dart';

class RouteHistoryGenerator {
  static const double _metersPerDegreeLat = 111320.0;
  static const double _metersPerDegreeLng = 111320.0 * 0.85;

  /// Generate a deterministic 1-hour walk history for a device.
  static List<RoutePoint> generateHistory(
    String deviceId,
    Location baseLocation, {
    int totalPoints = 360,
    int intervalSeconds = AppConstants.routeHistoryIntervalSeconds,
  }) {
    final random = Random(deviceId.hashCode);
    final now = DateTime.now();
    final startTime =
        now.subtract(Duration(seconds: (totalPoints - 1) * intervalSeconds));

    final points = <RoutePoint>[];
    double lat = baseLocation.latitude;
    double lng = baseLocation.longitude;
    double direction = random.nextDouble() * 2 * pi;

    // Generate waypoints for the walk route
    final waypoints = _generateWaypoints(
      random,
      baseLocation.latitude,
      baseLocation.longitude,
      direction,
    );
    int waypointIndex = 0;

    for (int i = 0; i < totalPoints; i++) {
      final timestamp =
          startTime.add(Duration(seconds: i * intervalSeconds));
      double speedMps;

      if (i < 90) {
        // Phase 1: Idle/waiting (0-15 min) — stationary with micro-movements
        speedMps = random.nextDouble() * 0.4;
        final jitter = 0.2 / _metersPerDegreeLat;
        lat += (random.nextDouble() - 0.5) * jitter;
        lng += (random.nextDouble() - 0.5) * jitter;
      } else if (i < 210) {
        // Phase 2: Walking (15-35 min) — follow waypoints
        speedMps = 0.8 + random.nextDouble() * 0.6; // 0.8–1.4 m/s
        final target = waypoints[waypointIndex % waypoints.length];
        final distToTarget = _distance(lat, lng, target[0], target[1]);

        if (distToTarget < 5) {
          waypointIndex++;
        }

        final wp = waypoints[waypointIndex % waypoints.length];
        direction = atan2(
          (wp[1] - lng) * _metersPerDegreeLng,
          (wp[0] - lat) * _metersPerDegreeLat,
        );
        direction += (random.nextDouble() - 0.5) * 0.3;

        final dist = speedMps * intervalSeconds;
        lat += (dist * cos(direction)) / _metersPerDegreeLat;
        lng += (dist * sin(direction)) / _metersPerDegreeLng;
      } else if (i < 270) {
        // Phase 3: Running (35-45 min) — fast, erratic
        speedMps = 2.0 + random.nextDouble() * 2.5; // 2.0–4.5 m/s
        direction += (random.nextDouble() - 0.5) * pi * 0.5;

        // Keep within bounds
        final distFromHome = _distance(
          lat,
          lng,
          baseLocation.latitude,
          baseLocation.longitude,
        );
        if (distFromHome > 250) {
          direction = atan2(
            (baseLocation.longitude - lng) * _metersPerDegreeLng,
            (baseLocation.latitude - lat) * _metersPerDegreeLat,
          );
        }

        final dist = speedMps * intervalSeconds;
        lat += (dist * cos(direction)) / _metersPerDegreeLat;
        lng += (dist * sin(direction)) / _metersPerDegreeLng;
      } else {
        // Phase 4: Returning home (45-60 min) — decelerating
        final progress = (i - 270) / 90.0; // 0.0 → 1.0
        speedMps = 1.5 * (1 - progress) + 0.2 * progress; // 1.5 → 0.2

        // Head toward home
        direction = atan2(
          (baseLocation.longitude - lng) * _metersPerDegreeLng,
          (baseLocation.latitude - lat) * _metersPerDegreeLat,
        );
        direction += (random.nextDouble() - 0.5) * 0.2;

        final dist = speedMps * intervalSeconds;
        lat += (dist * cos(direction)) / _metersPerDegreeLat;
        lng += (dist * sin(direction)) / _metersPerDegreeLng;
      }

      points.add(RoutePoint(
        location: Location(
          latitude: lat,
          longitude: lng,
          timestamp: timestamp,
        ),
        speedMps: speedMps,
      ));
    }

    return points;
  }

  static List<List<double>> _generateWaypoints(
    Random random,
    double baseLat,
    double baseLng,
    double baseDirection,
  ) {
    final waypoints = <List<double>>[];
    double lat = baseLat;
    double lng = baseLng;
    double dir = baseDirection;

    for (int i = 0; i < 6; i++) {
      dir += (random.nextDouble() - 0.5) * pi / 2;
      final distance = 40 + random.nextDouble() * 60; // 40–100m
      lat += (distance * cos(dir)) / _metersPerDegreeLat;
      lng += (distance * sin(dir)) / _metersPerDegreeLng;
      waypoints.add([lat, lng]);
    }

    return waypoints;
  }

  static double _distance(
      double lat1, double lng1, double lat2, double lng2) {
    final latDiff = (lat2 - lat1) * _metersPerDegreeLat;
    final lngDiff = (lng2 - lng1) * _metersPerDegreeLng;
    return sqrt(latDiff * latDiff + lngDiff * lngDiff);
  }
}
