import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../data/models/location.dart';
import '../../data/services/route_history_generator.dart';
import '../../domain/models/route_point.dart';
import '../utils/polyline_builder.dart';
import 'device_provider.dart';
import 'location_provider.dart';
import 'simulation_provider.dart';

/// Toggle state for showing the route on the map.
final showRouteProvider = StateProvider<bool>((ref) => false);

/// Manages the list of RoutePoints (history + real-time accumulation).
final routePointsProvider =
    StateNotifierProvider<RoutePointsNotifier, List<RoutePoint>>((ref) {
  return RoutePointsNotifier(ref);
});

/// Converts routePoints into a set of speed-colored Polylines.
/// Returns empty set when showRoute is off.
final routePolylinesProvider = Provider<Set<Polyline>>((ref) {
  final showRoute = ref.watch(showRouteProvider);
  if (!showRoute) return {};

  final points = ref.watch(routePointsProvider);
  return buildSpeedPolylines(points);
});

class RoutePointsNotifier extends StateNotifier<List<RoutePoint>> {
  final Ref _ref;
  String? _currentDeviceId;

  static const double _metersPerDegreeLat = 111320.0;
  static const double _metersPerDegreeLng = 111320.0 * 0.85;

  RoutePointsNotifier(this._ref) : super([]) {
    // Listen for device changes → clear and reload
    _ref.listen<String?>(selectedDeviceIdProvider, (prev, next) {
      if (prev != next) {
        _currentDeviceId = next;
        _onDeviceChanged();
      }
    }, fireImmediately: true);

    // Listen for showRoute toggle → load history when turned on
    _ref.listen<bool>(showRouteProvider, (prev, next) {
      if (next && state.isEmpty) {
        _loadHistoryForCurrentDevice();
      }
    });

    // Listen for simulation locations → append to route
    _ref.listen<AsyncValue<Location?>>(simulationLocationStreamProvider,
        (prev, next) {
      final showRoute = _ref.read(showRouteProvider);
      if (!showRoute) return;
      final location = next.valueOrNull;
      if (location != null) {
        appendLocation(location);
      }
    });

    // Listen for live tracking locations → append to route
    _ref.listen<AsyncValue<Location?>>(locationStreamProvider, (prev, next) {
      final showRoute = _ref.read(showRouteProvider);
      if (!showRoute) return;
      final location = next.valueOrNull;
      if (location != null) {
        appendLocation(location);
      }
    });
  }

  void _onDeviceChanged() {
    state = [];
    final showRoute = _ref.read(showRouteProvider);
    if (showRoute) {
      _loadHistoryForCurrentDevice();
    }
  }

  void _loadHistoryForCurrentDevice() {
    final deviceId = _currentDeviceId;
    if (deviceId == null) return;

    final baseLocation = Location(
      latitude: AppConstants.defaultLatitude,
      longitude: AppConstants.defaultLongitude,
      timestamp: DateTime.now(),
    );

    state = RouteHistoryGenerator.generateHistory(deviceId, baseLocation);
  }

  void appendLocation(Location location) {
    if (state.isEmpty) {
      state = [
        ...state,
        RoutePoint(location: location, speedMps: 0),
      ];
      return;
    }

    final last = state.last;
    final dt = location.timestamp
        .difference(last.location.timestamp)
        .inMilliseconds /
        1000.0;

    double speedMps = 0;
    if (dt > 0) {
      final latDiff =
          (location.latitude - last.location.latitude) * _metersPerDegreeLat;
      final lngDiff =
          (location.longitude - last.location.longitude) * _metersPerDegreeLng;
      final distance = sqrt(latDiff * latDiff + lngDiff * lngDiff);
      speedMps = distance / dt;
    }

    state = [
      ...state,
      RoutePoint(location: location, speedMps: speedMps),
    ];
  }

  void clear() {
    state = [];
  }
}
