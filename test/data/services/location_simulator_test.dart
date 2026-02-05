import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tailinq_app/data/models/location.dart';
import 'package:tailinq_app/data/services/location_simulator.dart';

void main() {
  late LocationSimulator simulator;
  final homeLocation = Location(
    latitude: 37.5665,
    longitude: 126.9780,
    timestamp: DateTime.now(),
  );

  setUp(() {
    simulator = LocationSimulator(homeLocation: homeLocation);
  });

  tearDown(() {
    simulator.dispose();
  });

  group('LocationSimulator', () {
    test('start() sets isRunning to true', () {
      expect(simulator.isRunning, isFalse);
      simulator.start();
      expect(simulator.isRunning, isTrue);
    });

    test('pause() sets isRunning to false', () {
      simulator.start();
      expect(simulator.isRunning, isTrue);

      simulator.pause();
      expect(simulator.isRunning, isFalse);
    });

    test('stop() resets currentLocation to homeLocation', () {
      simulator.setScenario(SimulationScenario.walking);
      simulator.start();

      // Let the simulator run briefly to move away from home
      // Then stop and verify it resets
      simulator.stop();

      expect(simulator.currentLocation.latitude, homeLocation.latitude);
      expect(simulator.currentLocation.longitude, homeLocation.longitude);
      expect(simulator.isRunning, isFalse);
    });

    test('setScenario(walking) changes scenario to walking', () {
      expect(simulator.scenario, SimulationScenario.idle);
      simulator.setScenario(SimulationScenario.walking);
      expect(simulator.scenario, SimulationScenario.walking);
    });

    test('setScenario changes scenario for all types', () {
      for (final scenario in SimulationScenario.values) {
        simulator.setScenario(scenario);
        expect(simulator.scenario, scenario);
      }
    });

    test('locationStream emits Location events after start', () async {
      final locations = <Location>[];
      final subscription = simulator.locationStream.listen((loc) {
        locations.add(loc);
      });

      simulator.start();

      // Wait for 2-3 emissions (1-second intervals)
      await Future.delayed(const Duration(milliseconds: 2500));

      simulator.pause();
      await subscription.cancel();

      expect(locations.length, greaterThanOrEqualTo(2));
      for (final loc in locations) {
        expect(loc, isA<Location>());
        expect(loc.latitude, isNotNull);
        expect(loc.longitude, isNotNull);
      }
    });

    test('walking scenario changes location over time', () async {
      simulator.setScenario(SimulationScenario.walking);

      final locations = <Location>[];
      final subscription = simulator.locationStream.listen((loc) {
        locations.add(loc);
      });

      simulator.start();
      await Future.delayed(const Duration(milliseconds: 3500));
      simulator.pause();
      await subscription.cancel();

      expect(locations.length, greaterThanOrEqualTo(2));

      // At least one pair of consecutive locations should differ
      bool hasMoved = false;
      for (int i = 1; i < locations.length; i++) {
        if (locations[i].latitude != locations[i - 1].latitude ||
            locations[i].longitude != locations[i - 1].longitude) {
          hasMoved = true;
          break;
        }
      }
      expect(hasMoved, isTrue, reason: 'Walking scenario should change location');
    });

    test('idle scenario has very small location changes', () async {
      simulator.setScenario(SimulationScenario.idle);

      final locations = <Location>[];
      final subscription = simulator.locationStream.listen((loc) {
        locations.add(loc);
      });

      simulator.start();
      await Future.delayed(const Duration(milliseconds: 3500));
      simulator.pause();
      await subscription.cancel();

      expect(locations.length, greaterThanOrEqualTo(2));

      // All locations should be very close to home (idle jitter is ~0.000001 degrees)
      for (final loc in locations) {
        final latDiff = (loc.latitude - homeLocation.latitude).abs();
        final lngDiff = (loc.longitude - homeLocation.longitude).abs();
        // Idle jitter max is randomnessFactor(0.1) * 0.00001 = 0.000001
        // Accumulated over a few seconds, should still be tiny
        expect(latDiff, lessThan(0.0001),
            reason: 'Idle location should stay very close to home');
        expect(lngDiff, lessThan(0.0001),
            reason: 'Idle location should stay very close to home');
      }
    });

    test('stop() emits home location on the stream', () async {
      final completer = Completer<Location>();
      simulator.start();

      // Skip initial emissions, capture the one from stop()
      late StreamSubscription<Location> subscription;
      subscription = simulator.locationStream.listen((loc) {
        if (!simulator.isRunning) {
          completer.complete(loc);
          subscription.cancel();
        }
      });

      // Let it run briefly then stop
      await Future.delayed(const Duration(milliseconds: 500));
      simulator.stop();

      final stoppedLocation = await completer.future.timeout(
        const Duration(seconds: 2),
      );
      expect(stoppedLocation.latitude, homeLocation.latitude);
      expect(stoppedLocation.longitude, homeLocation.longitude);
    });

    test('start() does nothing if already running', () {
      simulator.start();
      expect(simulator.isRunning, isTrue);

      // Calling start again should not throw or change state
      simulator.start();
      expect(simulator.isRunning, isTrue);
    });

    test('homeLocation getter returns the configured home', () {
      expect(simulator.homeLocation.latitude, homeLocation.latitude);
      expect(simulator.homeLocation.longitude, homeLocation.longitude);
    });

    test('setHomeLocation updates home and current location', () {
      final newHome = Location(
        latitude: 35.0,
        longitude: 129.0,
        timestamp: DateTime.now(),
      );
      simulator.setHomeLocation(newHome);

      expect(simulator.homeLocation.latitude, 35.0);
      expect(simulator.currentLocation.latitude, 35.0);
    });
  });

  group('SimulationConfig', () {
    test('idle config has zero speed', () {
      final config = SimulationConfig.forScenario(SimulationScenario.idle);
      expect(config.speedMetersPerSecond, 0.0);
    });

    test('walking config has moderate speed', () {
      final config = SimulationConfig.forScenario(SimulationScenario.walking);
      expect(config.speedMetersPerSecond, 1.2);
    });

    test('running config has higher speed than walking', () {
      final walking = SimulationConfig.forScenario(SimulationScenario.walking);
      final running = SimulationConfig.forScenario(SimulationScenario.running);
      expect(running.speedMetersPerSecond,
          greaterThan(walking.speedMetersPerSecond));
    });

    test('each scenario returns a valid config', () {
      for (final scenario in SimulationScenario.values) {
        final config = SimulationConfig.forScenario(scenario);
        expect(config.speedMetersPerSecond, greaterThanOrEqualTo(0));
        expect(config.directionChangeFrequency, greaterThanOrEqualTo(0));
        expect(config.randomnessFactor, greaterThanOrEqualTo(0));
      }
    });
  });

  group('SimulationScenario', () {
    test('has label and description', () {
      for (final scenario in SimulationScenario.values) {
        expect(scenario.label, isNotEmpty);
        expect(scenario.description, isNotEmpty);
      }
    });

    test('contains 5 scenarios', () {
      expect(SimulationScenario.values.length, 5);
    });
  });
}
