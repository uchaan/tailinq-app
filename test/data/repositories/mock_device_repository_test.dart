import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tailinq_app/data/models/location.dart';
import 'package:tailinq_app/data/repositories/mock_device_repository.dart';

void main() {
  late MockDeviceRepository repository;

  setUp(() {
    repository = MockDeviceRepository();
  });

  tearDown(() {
    repository.dispose();
  });

  group('MockDeviceRepository', () {
    group('getDevices()', () {
      test('returns 2 devices', () async {
        final devices = await repository.getDevices();
        expect(devices.length, 2);
      });

      test('returns devices with valid IDs', () async {
        final devices = await repository.getDevices();
        final ids = devices.map((d) => d.id).toSet();
        expect(ids, contains('device-1'));
        expect(ids, contains('device-2'));
      });
    });

    group('getDevice()', () {
      test('returns correct device for device-1', () async {
        final device = await repository.getDevice('device-1');
        expect(device, isNotNull);
        expect(device!.id, 'device-1');
        expect(device.batteryLevel, 85);
      });

      test('returns correct device for device-2', () async {
        final device = await repository.getDevice('device-2');
        expect(device, isNotNull);
        expect(device!.id, 'device-2');
        expect(device.batteryLevel, 45);
      });

      test('returns null for nonexistent device', () async {
        final device = await repository.getDevice('nonexistent');
        expect(device, isNull);
      });

      test('returns null for empty ID', () async {
        final device = await repository.getDevice('');
        expect(device, isNull);
      });
    });

    group('toggleLiveMode()', () {
      test('enables live mode', () async {
        // Initially isLiveMode is false
        var device = await repository.getDevice('device-1');
        expect(device!.isLiveMode, isFalse);

        await repository.toggleLiveMode('device-1', true);

        device = await repository.getDevice('device-1');
        expect(device!.isLiveMode, isTrue);
      });

      test('disables live mode', () async {
        await repository.toggleLiveMode('device-1', true);
        var device = await repository.getDevice('device-1');
        expect(device!.isLiveMode, isTrue);

        await repository.toggleLiveMode('device-1', false);
        device = await repository.getDevice('device-1');
        expect(device!.isLiveMode, isFalse);
      });

      test('does nothing for nonexistent device', () async {
        // Should not throw
        await repository.toggleLiveMode('nonexistent', true);
      });
    });

    group('getLocationStream()', () {
      test('emits location when live mode is ON', () async {
        await repository.toggleLiveMode('device-1', true);

        final stream = repository.getLocationStream('device-1');
        final locations = <Location>[];

        final subscription = stream.listen((loc) {
          locations.add(loc);
        });

        // Wait for at least one emission (2-second interval)
        await Future.delayed(const Duration(milliseconds: 2500));

        await subscription.cancel();
        expect(locations, isNotEmpty,
            reason: 'Stream should emit when live mode is ON');
      });

      test('does not emit when live mode is OFF', () async {
        // Device starts with isLiveMode = false
        final stream = repository.getLocationStream('device-1');
        final locations = <Location>[];

        final subscription = stream.listen((loc) {
          locations.add(loc);
        });

        // Wait for potential emission window
        await Future.delayed(const Duration(milliseconds: 2500));

        await subscription.cancel();
        expect(locations, isEmpty,
            reason: 'Stream should not emit when live mode is OFF');
      });

      test('emitted location matches device lastLocation (no coordinate manipulation)', () async {
        // Get the device's current lastLocation
        final device = await repository.getDevice('device-1');
        final expectedLat = device!.lastLocation!.latitude;
        final expectedLng = device.lastLocation!.longitude;

        await repository.toggleLiveMode('device-1', true);
        final stream = repository.getLocationStream('device-1');

        final completer = Completer<Location>();
        final subscription = stream.listen((loc) {
          if (!completer.isCompleted) {
            completer.complete(loc);
          }
        });

        final emittedLocation = await completer.future.timeout(
          const Duration(seconds: 5),
        );

        await subscription.cancel();

        // The emitted location should exactly match the device's lastLocation
        // (repository should NOT manipulate coordinates)
        expect(emittedLocation.latitude, expectedLat,
            reason: 'Repository must not alter latitude');
        expect(emittedLocation.longitude, expectedLng,
            reason: 'Repository must not alter longitude');
      });

      test('returns a broadcast stream', () async {
        await repository.toggleLiveMode('device-1', true);
        final stream = repository.getLocationStream('device-1');

        // Broadcast streams allow multiple listeners
        final sub1 = stream.listen((_) {});
        final sub2 = stream.listen((_) {});

        await sub1.cancel();
        await sub2.cancel();
      });
    });
  });
}
