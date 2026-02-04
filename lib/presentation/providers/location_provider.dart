import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/location.dart';
import 'device_provider.dart';
import 'simulation_provider.dart';

final locationStreamProvider = StreamProvider<Location?>((ref) {
  final deviceId = ref.watch(selectedDeviceIdProvider);
  final isLiveMode = ref.watch(isLiveModeProvider);
  final simulationState = ref.watch(simulationProvider);

  if (deviceId == null || !isLiveMode) {
    return Stream.value(null);
  }

  // 시뮬레이션이 활성화되어 있으면 시뮬레이션 위치 스트림 사용
  if (simulationState.isEnabled && simulationState.isRunning) {
    final notifier = ref.read(simulationProvider.notifier);
    return notifier.simulator.locationStream;
  }

  // 기본 위치 스트림
  final repository = ref.watch(deviceRepositoryProvider);
  return repository.getLocationStream(deviceId);
});
