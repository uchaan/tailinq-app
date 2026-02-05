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
}
