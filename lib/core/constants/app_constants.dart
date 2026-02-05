class AppConstants {
  static const String appName = 'Tailinq';
  static const Duration locationUpdateInterval = Duration(seconds: 2);
  static const double defaultSafeZoneRadius = 100.0;
  static const double defaultLatitude = 37.5209;
  static const double defaultLongitude = 127.1230;

  // Speed thresholds (m/s) for route coloring
  static const double speedThresholdStationary = 0.5;
  static const double speedThresholdWalking = 1.5;
  static const double speedThresholdJogging = 3.0;

  // Route history settings
  static const int routeHistoryDurationMinutes = 60;
  static const int routeHistoryIntervalSeconds = 10;

  // Geofence defaults
  static const double defaultGeofenceRadius = 100.0;
  static const double minGeofenceRadius = 25.0;
  static const double maxGeofenceRadius = 1000.0;

  static const List<int> geofenceColors = [
    0xFF4CAF50, // green
    0xFF2196F3, // blue
    0xFFFF9800, // orange
    0xFF9C27B0, // purple
    0xFFE91E63, // pink
    0xFF00BCD4, // cyan
    0xFFFF5722, // deep orange
    0xFF795548, // brown
  ];
}
