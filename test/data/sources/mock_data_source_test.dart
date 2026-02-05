import 'package:flutter_test/flutter_test.dart';
import 'package:tailinq_app/core/constants/app_constants.dart';
import 'package:tailinq_app/data/models/location.dart';
import 'package:tailinq_app/data/sources/mock_data_source.dart';

void main() {
  late MockDataSource dataSource;

  setUp(() {
    dataSource = MockDataSource();
  });

  group('MockDataSource', () {
    group('getMockDevices()', () {
      test('returns 2 devices', () {
        final devices = dataSource.getMockDevices();
        expect(devices.length, 2);
      });

      test('first device is device-1 with correct properties', () {
        final devices = dataSource.getMockDevices();
        final device1 = devices.firstWhere((d) => d.id == 'device-1');

        expect(device1.batteryLevel, 85);
        expect(device1.isLiveMode, isFalse);
        expect(device1.petId, 'pet-1');
        expect(device1.safeZoneRadius, 100.0);
        expect(device1.lastLocation, isNotNull);
      });

      test('second device is device-2 with correct properties', () {
        final devices = dataSource.getMockDevices();
        final device2 = devices.firstWhere((d) => d.id == 'device-2');

        expect(device2.batteryLevel, 45);
        expect(device2.isLiveMode, isFalse);
        expect(device2.petId, 'pet-2');
        expect(device2.safeZoneRadius, 150.0);
        expect(device2.lastLocation, isNotNull);
      });

      test('device-1 location uses default coordinates', () {
        final devices = dataSource.getMockDevices();
        final device1 = devices.firstWhere((d) => d.id == 'device-1');

        expect(device1.lastLocation!.latitude, AppConstants.defaultLatitude);
        expect(device1.lastLocation!.longitude, AppConstants.defaultLongitude);
      });

      test('device-2 location is offset from default', () {
        final devices = dataSource.getMockDevices();
        final device2 = devices.firstWhere((d) => d.id == 'device-2');

        expect(device2.lastLocation!.latitude,
            AppConstants.defaultLatitude + 0.002);
        expect(device2.lastLocation!.longitude,
            AppConstants.defaultLongitude + 0.002);
      });
    });

    group('generateRandomLocation()', () {
      test('returns a location near the base', () {
        final base = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          timestamp: DateTime.now(),
        );

        final generated = dataSource.generateRandomLocation(base);

        final latDiff = (generated.latitude - base.latitude).abs();
        final lngDiff = (generated.longitude - base.longitude).abs();

        // Offset max is 0.5 * 0.00005 = 0.000025 degrees
        expect(latDiff, lessThan(0.00005),
            reason: 'Latitude offset should be within ~5.5m');
        expect(lngDiff, lessThan(0.00005),
            reason: 'Longitude offset should be within ~5.5m');
      });

      test('generates different locations on multiple calls', () {
        final base = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          timestamp: DateTime.now(),
        );

        // Generate many locations and check they're not all identical
        final locations =
            List.generate(10, (_) => dataSource.generateRandomLocation(base));

        final uniqueLatitudes = locations.map((l) => l.latitude).toSet();
        // With random generation, extremely unlikely all 10 are identical
        expect(uniqueLatitudes.length, greaterThan(1),
            reason: 'Random locations should vary');
      });

      test('offset is within ~5.5m (0.00005 degrees)', () {
        final base = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          timestamp: DateTime.now(),
        );

        // Run 100 times to increase confidence
        for (int i = 0; i < 100; i++) {
          final generated = dataSource.generateRandomLocation(base);
          final latDiff = (generated.latitude - base.latitude).abs();
          final lngDiff = (generated.longitude - base.longitude).abs();

          expect(latDiff, lessThanOrEqualTo(0.000025),
              reason: 'Lat offset should be <= 0.000025 degrees (iteration $i)');
          expect(lngDiff, lessThanOrEqualTo(0.000025),
              reason: 'Lng offset should be <= 0.000025 degrees (iteration $i)');
        }
      });

      test('generated location has a timestamp', () {
        final base = Location(
          latitude: 37.5665,
          longitude: 126.9780,
          timestamp: DateTime.now(),
        );

        final generated = dataSource.generateRandomLocation(base);
        expect(generated.timestamp, isNotNull);
      });
    });
  });
}
