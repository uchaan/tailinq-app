import '../../data/models/location.dart';

class RoutePoint {
  final Location location;
  final double speedMps;

  const RoutePoint({required this.location, required this.speedMps});
}
