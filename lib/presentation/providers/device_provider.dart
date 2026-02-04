import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/device.dart';
import '../../data/repositories/mock_device_repository.dart';
import 'simulation_provider.dart';

final deviceRepositoryProvider = Provider<MockDeviceRepository>((ref) {
  final repository = MockDeviceRepository();

  // 시뮬레이션 상태 변경 시 시뮬레이터 연결
  ref.listen(simulationProvider, (previous, next) {
    if (next.isEnabled && next.isRunning) {
      final notifier = ref.read(simulationProvider.notifier);
      repository.setSimulator(notifier.simulator);
    } else {
      repository.setSimulator(null);
    }
  });

  ref.onDispose(() => repository.dispose());
  return repository;
});

final devicesProvider = FutureProvider<List<Device>>((ref) async {
  final repository = ref.watch(deviceRepositoryProvider);
  return repository.getDevices();
});

final selectedDeviceIdProvider = StateProvider<String?>((ref) => 'device-1');

final selectedDeviceProvider = FutureProvider<Device?>((ref) async {
  final deviceId = ref.watch(selectedDeviceIdProvider);
  if (deviceId == null) return null;
  final repository = ref.watch(deviceRepositoryProvider);
  return repository.getDevice(deviceId);
});

final isLiveModeProvider =
    StateNotifierProvider<LiveModeNotifier, bool>((ref) {
  return LiveModeNotifier(ref);
});

class LiveModeNotifier extends StateNotifier<bool> {
  final Ref _ref;

  LiveModeNotifier(this._ref) : super(false);

  Future<void> toggle() async {
    final deviceId = _ref.read(selectedDeviceIdProvider);
    if (deviceId == null) return;

    state = !state;
    final repository = _ref.read(deviceRepositoryProvider);
    await repository.toggleLiveMode(deviceId, state);
  }
}
