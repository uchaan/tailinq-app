import 'package:flutter_test/flutter_test.dart';
import 'package:tailinq_app/data/services/location_simulator.dart';
import 'package:tailinq_app/presentation/providers/simulation_provider.dart';

void main() {
  late SimulationNotifier notifier;

  setUp(() {
    notifier = SimulationNotifier();
  });

  tearDown(() {
    notifier.dispose();
  });

  group('SimulationNotifier', () {
    group('initial state', () {
      test('isEnabled is false', () {
        expect(notifier.state.isEnabled, isFalse);
      });

      test('isRunning is false', () {
        expect(notifier.state.isRunning, isFalse);
      });

      test('scenario is idle', () {
        expect(notifier.state.scenario, SimulationScenario.idle);
      });
    });

    group('toggleEnabled()', () {
      test('first call sets isEnabled to true', () {
        notifier.toggleEnabled();
        expect(notifier.state.isEnabled, isTrue);
      });

      test('second call sets isEnabled back to false', () {
        notifier.toggleEnabled(); // enable
        notifier.toggleEnabled(); // disable
        expect(notifier.state.isEnabled, isFalse);
      });

      test('disabling resets isRunning to false', () {
        notifier.toggleEnabled(); // enable
        notifier.toggleRunning(); // start running
        expect(notifier.state.isRunning, isTrue);

        notifier.toggleEnabled(); // disable
        expect(notifier.state.isRunning, isFalse);
      });

      test('disabling resets scenario to idle', () {
        notifier.toggleEnabled();
        notifier.setScenario(SimulationScenario.walking);
        expect(notifier.state.scenario, SimulationScenario.walking);

        notifier.toggleEnabled(); // disable
        expect(notifier.state.scenario, SimulationScenario.idle);
      });
    });

    group('toggleRunning()', () {
      test('does nothing when not enabled', () {
        notifier.toggleRunning();
        expect(notifier.state.isRunning, isFalse);
      });

      test('starts running when enabled', () {
        notifier.toggleEnabled();
        notifier.toggleRunning();
        expect(notifier.state.isRunning, isTrue);
      });

      test('pauses when called again while running', () {
        notifier.toggleEnabled();
        notifier.toggleRunning(); // start
        expect(notifier.state.isRunning, isTrue);

        notifier.toggleRunning(); // pause
        expect(notifier.state.isRunning, isFalse);
      });

      test('can resume after pause', () {
        notifier.toggleEnabled();
        notifier.toggleRunning(); // start
        notifier.toggleRunning(); // pause
        notifier.toggleRunning(); // resume
        expect(notifier.state.isRunning, isTrue);
      });
    });

    group('setScenario()', () {
      test('changes scenario to walking', () {
        notifier.setScenario(SimulationScenario.walking);
        expect(notifier.state.scenario, SimulationScenario.walking);
      });

      test('changes scenario to running', () {
        notifier.setScenario(SimulationScenario.running);
        expect(notifier.state.scenario, SimulationScenario.running);
      });

      test('changes scenario to exploring', () {
        notifier.setScenario(SimulationScenario.exploring);
        expect(notifier.state.scenario, SimulationScenario.exploring);
      });

      test('changes scenario to returning', () {
        notifier.setScenario(SimulationScenario.returning);
        expect(notifier.state.scenario, SimulationScenario.returning);
      });
    });

    group('simulator access', () {
      test('lazily initializes simulator on first access', () {
        // Access the simulator property
        final sim = notifier.simulator;
        expect(sim, isA<LocationSimulator>());
      });

      test('returns the same simulator instance on subsequent access', () {
        final sim1 = notifier.simulator;
        final sim2 = notifier.simulator;
        expect(identical(sim1, sim2), isTrue);
      });
    });
  });

  group('SimulationState', () {
    test('default constructor has correct defaults', () {
      const state = SimulationState();
      expect(state.isEnabled, isFalse);
      expect(state.isRunning, isFalse);
      expect(state.scenario, SimulationScenario.idle);
    });

    test('copyWith preserves unchanged fields', () {
      const state = SimulationState(
        isEnabled: true,
        isRunning: true,
        scenario: SimulationScenario.walking,
      );

      final copied = state.copyWith(isRunning: false);
      expect(copied.isEnabled, isTrue); // preserved
      expect(copied.isRunning, isFalse); // changed
      expect(copied.scenario, SimulationScenario.walking); // preserved
    });

    test('copyWith can change all fields', () {
      const state = SimulationState();
      final copied = state.copyWith(
        isEnabled: true,
        isRunning: true,
        scenario: SimulationScenario.running,
      );

      expect(copied.isEnabled, isTrue);
      expect(copied.isRunning, isTrue);
      expect(copied.scenario, SimulationScenario.running);
    });
  });
}
