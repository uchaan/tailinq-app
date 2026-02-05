import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/location.dart';
import '../../../data/models/pet.dart';
import '../../providers/device_provider.dart';
import '../../providers/geofence_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/marker_icon_provider.dart';
import '../../providers/pet_provider.dart';
import '../../providers/route_provider.dart';
import '../../providers/simulation_provider.dart';
import '../../widgets/device_bottom_sheet.dart';
import '../../widgets/speed_legend_overlay.dart';

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
    final simulationLocationAsync = ref.watch(simulationLocationStreamProvider);

    // 경로 polylines
    final routePolylines = ref.watch(routePolylinesProvider);

    // 커스텀 마커 아이콘
    final markerIconAsync = ref.watch(petMarkerIconProvider);

    // Geofence circles
    final geofenceCircles = ref.watch(geofenceCirclesProvider);

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
        toolbarHeight: 40,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, size: 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {},
          ),
          const SizedBox(width: 12),
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
            simulationLocationAsync,
            routePolylines,
            markerIconAsync,
            geofenceCircles,
          ),

          // Speed legend overlay (top-left)
          const Positioned(
            top: 16,
            left: 16,
            child: SpeedLegendOverlay(),
          ),

          // 포커스 버튼 (지도 위 오버레이)
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: 'focusButton',
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              onPressed: () {
                // 현재 마커 위치로 카메라 이동
                Location? currentLocation;
                // 1순위: 시뮬레이션
                if (simulationState.isEnabled && simulationState.isRunning) {
                  currentLocation = simulationLocationAsync.valueOrNull;
                }
                // 2순위: 라이브 트래킹
                if (currentLocation == null && isLiveMode) {
                  currentLocation = locationAsync.valueOrNull;
                }
                // 3순위: 마지막 위치
                currentLocation ??= selectedDeviceAsync.valueOrNull?.lastLocation;

                if (currentLocation != null) {
                  _focusOnLocation(currentLocation);
                }
              },
              child: const Icon(Icons.my_location),
            ),
          ),

          // Bottom sheet
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
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
    AsyncValue<Location?> simulationLocationAsync,
    Set<Polyline> routePolylines,
    AsyncValue<BitmapDescriptor> markerIconAsync,
    Set<Circle> geofenceCircles,
  ) {
    // Build markers
    final markers = <Marker>{};
    final petName = selectedPetAsync.valueOrNull?.name ?? 'Unknown';

    selectedDeviceAsync.whenData((device) {
      if (device == null) return;

      Location? markerLocation;

      // 1순위: 시뮬레이션
      if (simulationState.isEnabled && simulationState.isRunning) {
        markerLocation = simulationLocationAsync.valueOrNull;
      }
      // 2순위: 라이브 트래킹
      if (markerLocation == null && isLiveMode) {
        markerLocation = locationAsync.valueOrNull;
      }
      // 3순위: 마지막 위치
      markerLocation ??= device.lastLocation;

      if (markerLocation != null) {
        final isSimulating = simulationState.isEnabled && simulationState.isRunning;

        markers.add(
          Marker(
            markerId: MarkerId(device.id),
            position: LatLng(markerLocation.latitude, markerLocation.longitude),
            infoWindow: InfoWindow(
              title: petName,
              snippet: isSimulating
                  ? 'Simulating: ${simulationState.scenario.label}'
                  : (isLiveMode ? 'Live Tracking' : 'Last known location'),
            ),
            icon: markerIconAsync.valueOrNull ??
                BitmapDescriptor.defaultMarkerWithHue(
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
      polylines: routePolylines,
      circles: geofenceCircles,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
      mapToolbarEnabled: false,
      compassEnabled: true,
    );
  }
}
