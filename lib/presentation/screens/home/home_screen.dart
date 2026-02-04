import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/location.dart';
import '../../../data/models/pet.dart';
import '../../providers/device_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/pet_provider.dart';
import '../../providers/simulation_provider.dart';
import '../../widgets/device_bottom_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GoogleMapController? _mapController;
  bool _hasInitiallyFocused = false;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude),
    zoom: 16,
  );

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _focusOnLocation(Location location) async {
    if (!mounted || _mapController == null) return;

    await _mapController!.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(location.latitude, location.longitude),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedDeviceAsync = ref.watch(selectedDeviceProvider);
    final selectedPetAsync = ref.watch(selectedPetProvider);
    final locationAsync = ref.watch(locationStreamProvider);
    final isLiveMode = ref.watch(isLiveModeProvider);
    final simulationState = ref.watch(simulationProvider);

    // 시뮬레이션 위치도 watch (마커 업데이트용)
    final simulationLocation = simulationState.isEnabled && simulationState.isRunning
        ? ref.watch(simulationLocationStreamProvider).valueOrNull
        : null;

    // 초기 포커스 설정 (한 번만)
    if (!_hasInitiallyFocused) {
      selectedDeviceAsync.whenData((device) {
        if (device?.lastLocation != null) {
          _hasInitiallyFocused = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _focusOnLocation(device!.lastLocation!);
          });
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          // 현재 위치로 포커스 버튼
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              // 현재 마커 위치로 카메라 이동
              Location? currentLocation;
              if (simulationState.isEnabled && simulationState.isRunning) {
                currentLocation = simulationLocation;
              } else if (isLiveMode) {
                currentLocation = locationAsync.valueOrNull;
              }
              currentLocation ??= selectedDeviceAsync.valueOrNull?.lastLocation;

              if (currentLocation != null) {
                _focusOnLocation(currentLocation);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map
          _buildGoogleMap(
            selectedDeviceAsync,
            selectedPetAsync,
            locationAsync,
            isLiveMode,
            simulationState,
            simulationLocation,
          ),

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
                final pet = selectedPetAsync.valueOrNull;
                return DeviceBottomSheet(device: device, pet: pet);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(child: Text('Error loading device')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleMap(
    AsyncValue<dynamic> selectedDeviceAsync,
    AsyncValue<Pet?> selectedPetAsync,
    AsyncValue<Location?> locationAsync,
    bool isLiveMode,
    SimulationState simulationState,
    Location? simulationLocation,
  ) {
    // Build markers
    final markers = <Marker>{};
    final petName = selectedPetAsync.valueOrNull?.name ?? 'Unknown';

    selectedDeviceAsync.whenData((device) {
      if (device == null) return;

      Location? markerLocation;

      // 우선순위: 시뮬레이션 > 라이브 스트림 > 마지막 위치
      if (simulationState.isEnabled && simulationState.isRunning && simulationLocation != null) {
        markerLocation = simulationLocation;
      } else if (isLiveMode) {
        locationAsync.whenData((loc) {
          markerLocation = loc;
        });
      }

      markerLocation ??= device.lastLocation;

      if (markerLocation != null) {
        final isSimulating = simulationState.isEnabled && simulationState.isRunning;

        markers.add(
          Marker(
            markerId: MarkerId(device.id),
            position: LatLng(markerLocation!.latitude, markerLocation!.longitude),
            infoWindow: InfoWindow(
              title: petName,
              snippet: isSimulating
                  ? 'Simulating: ${simulationState.scenario.label}'
                  : (isLiveMode ? 'Live Tracking' : 'Last known location'),
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              isSimulating
                  ? BitmapDescriptor.hueOrange
                  : (isLiveMode ? BitmapDescriptor.hueRed : BitmapDescriptor.hueGreen),
            ),
          ),
        );
      }
    });

    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: _initialPosition,
      markers: markers,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
      mapToolbarEnabled: false,
      compassEnabled: true,
    );
  }
}
