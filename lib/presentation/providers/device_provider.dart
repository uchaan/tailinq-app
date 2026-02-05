import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/device.dart';
import '../../data/repositories/mock_device_repository.dart';
import 'pet_provider.dart';

final deviceRepositoryProvider = Provider<MockDeviceRepository>((ref) {
  final repository = MockDeviceRepository();
  ref.onDispose(() => repository.dispose());
  return repository;
});

final devicesProvider = FutureProvider<List<Device>>((ref) async {
  final repository = ref.watch(deviceRepositoryProvider);
  return repository.getDevices();
});

final selectedDeviceIdProvider = Provider<String?>((ref) {
  final petAsync = ref.watch(selectedPetProvider);
  return petAsync.valueOrNull?.deviceId;
});

final selectedDeviceProvider = FutureProvider<Device?>((ref) async {
  final deviceId = ref.watch(selectedDeviceIdProvider);
  if (deviceId == null) return null;
  final repository = ref.watch(deviceRepositoryProvider);
  return repository.getDevice(deviceId);
});

final bottomSheetExpandedProvider = StateProvider<bool>((ref) => true);

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
