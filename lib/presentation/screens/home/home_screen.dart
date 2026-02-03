import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/device_provider.dart';
import '../../providers/location_provider.dart';
import '../../widgets/device_bottom_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDeviceAsync = ref.watch(selectedDeviceProvider);
    final locationAsync = ref.watch(locationStreamProvider);
    final isLiveMode = ref.watch(isLiveModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map placeholder
          _buildMapPlaceholder(ref, locationAsync, isLiveMode),
          // Bottom sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: selectedDeviceAsync.when(
              data: (device) {
                if (device == null) {
                  return const SizedBox.shrink();
                }
                return DeviceBottomSheet(device: device);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text('Error loading device')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder(
    WidgetRef ref,
    AsyncValue<dynamic> locationAsync,
    bool isLiveMode,
  ) {
    final selectedDeviceAsync = ref.watch(selectedDeviceProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green[100]!,
            Colors.green[50]!,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Grid pattern to simulate map
          CustomPaint(
            size: Size.infinite,
            painter: MapGridPainter(),
          ),
          // Device marker
          selectedDeviceAsync.when(
            data: (device) {
              if (device == null) return const SizedBox.shrink();

              final location = device.lastLocation;
              if (location == null) return const SizedBox.shrink();

              return LayoutBuilder(
                builder: (context, constraints) {
                  final centerX = constraints.maxWidth / 2;
                  final centerY = constraints.maxHeight / 2 - 80;

                  double offsetX = 0;
                  double offsetY = 0;

                  if (isLiveMode) {
                    locationAsync.whenData((loc) {
                      if (loc != null) {
                        offsetX =
                            (loc.longitude - AppConstants.defaultLongitude) *
                                50000;
                        offsetY =
                            (loc.latitude - AppConstants.defaultLatitude) *
                                -50000;
                      }
                    });
                  }

                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    left: centerX + offsetX - 20,
                    top: centerY + offsetY - 40,
                    child: _buildMarker(device.name, isLiveMode),
                  );
                },
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          // Center indicator
          Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(128),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarker(String name, bool isLiveMode) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(38),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isLiveMode ? Colors.red : Colors.green,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isLiveMode ? Colors.red : Colors.green).withAlpha(102),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.pets,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withAlpha(51)
      ..strokeWidth = 1;

    const spacing = 50.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
