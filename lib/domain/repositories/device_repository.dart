import '../../data/models/device.dart';
import '../../data/models/location.dart';

abstract class DeviceRepository {
  Future<List<Device>> getDevices();
  Future<Device?> getDevice(String id);
  Stream<Location> getLocationStream(String deviceId);
  Future<void> toggleLiveMode(String deviceId, bool isLive);
}
