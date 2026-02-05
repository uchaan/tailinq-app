import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/location.dart';
import 'device_provider.dart';

final locationStreamProvider = StreamProvider<Location?>((ref) {
  final deviceId = ref.watch(selectedDeviceIdProvider);
  final isLiveMode = ref.watch(isLiveModeProvider);

  if (deviceId == null || !isLiveMode) {
    return Stream.value(null);
  }

  // 순수 라이브 트래킹만 (시뮬레이션 관련 코드 제거)
  final repository = ref.watch(deviceRepositoryProvider);
  return repository.getLocationStream(deviceId);
});
