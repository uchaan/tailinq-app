import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/location.dart';
import '../../../data/models/pet.dart';
import '../../providers/device_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/pet_provider.dart';
import '../../widgets/device_bottom_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GoogleMapController? _mapController;

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

  Future<void> _animateToLocation(Location location) async {
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

    // Listen to location changes and animate camera in live mode
    ref.listen<AsyncValue<Location?>>(locationStreamProvider, (previous, next) {
      if (isLiveMode) {
        next.whenData((location) {
          if (location != null) {
            _animateToLocation(location);
          }
        });
      }
    });

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
          // Google Map
          _buildGoogleMap(selectedDeviceAsync, selectedPetAsync, locationAsync, isLiveMode),

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
              error: (_, __) => const Center(child: Text('Error loading device')),
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
  ) {
    // Build markers
    final markers = <Marker>{};
    final petName = selectedPetAsync.valueOrNull?.name ?? 'Unknown';

    selectedDeviceAsync.whenData((device) {
      if (device == null) return;

      Location? markerLocation;

      // Use live location if available in live mode, otherwise use last known location
      if (isLiveMode) {
        locationAsync.whenData((loc) {
          markerLocation = loc;
        });
      }

      markerLocation ??= device.lastLocation;

      if (markerLocation != null) {
        markers.add(
          Marker(
            markerId: MarkerId(device.id),
            position: LatLng(markerLocation!.latitude, markerLocation!.longitude),
            infoWindow: InfoWindow(
              title: petName,
              snippet: isLiveMode ? 'Live Tracking' : 'Last known location',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              isLiveMode ? BitmapDescriptor.hueRed : BitmapDescriptor.hueGreen,
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
