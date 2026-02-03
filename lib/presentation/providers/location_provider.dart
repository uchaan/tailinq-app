import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/location.dart';
import 'device_provider.dart';

final locationStreamProvider = StreamProvider<Location?>((ref) {
  final deviceId = ref.watch(selectedDeviceIdProvider);
  final isLiveMode = ref.watch(isLiveModeProvider);

  if (deviceId == null || !isLiveMode) {
    return Stream.value(null);
  }

  final repository = ref.watch(deviceRepositoryProvider);
  return repository.getLocationStream(deviceId);
});
