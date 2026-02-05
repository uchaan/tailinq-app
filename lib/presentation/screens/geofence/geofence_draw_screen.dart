import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../providers/geofence_provider.dart';

class GeofenceDrawScreen extends ConsumerStatefulWidget {
  const GeofenceDrawScreen({super.key});

  @override
  ConsumerState<GeofenceDrawScreen> createState() => _GeofenceDrawScreenState();
}

class _GeofenceDrawScreenState extends ConsumerState<GeofenceDrawScreen> {
  GoogleMapController? _mapController;
  final _nameController = TextEditingController();

  LatLng? _center;
  double _radius = AppConstants.defaultGeofenceRadius;
  int _selectedColor = AppConstants.geofenceColors[0];

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude),
    zoom: 16,
  );

  @override
  void dispose() {
    _mapController?.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Set<Circle> _buildPreviewCircles() {
    if (_center == null) return {};
    final color = Color(_selectedColor);
    return {
      Circle(
        circleId: const CircleId('preview'),
        center: _center!,
        radius: _radius,
        fillColor: color.withAlpha(38),
        strokeColor: color.withAlpha(153),
        strokeWidth: 2,
      ),
    };
  }

  Set<Marker> _buildMarkers() {
    if (_center == null) return {};
    return {
      Marker(
        markerId: const MarkerId('center'),
        position: _center!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    };
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _center == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set a name and tap the map to place the geofence')),
      );
      return;
    }

    await ref.read(selectedPetGeofencesProvider.notifier).createAndAssign(
          name: name,
          latitude: _center!.latitude,
          longitude: _center!.longitude,
          radiusMeters: _radius,
          color: _selectedColor,
        );

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draw Geofence'),
      ),
      body: Column(
        children: [
          // Map area
          Expanded(
            flex: 3,
            child: GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: _initialPosition,
              onTap: (latLng) {
                setState(() {
                  _center = latLng;
                });
              },
              circles: _buildPreviewCircles(),
              markers: _buildMarkers(),
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              mapToolbarEnabled: false,
            ),
          ),
          // Settings panel
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Instruction
                  if (_center == null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.touch_app, color: Colors.green[700]),
                          const SizedBox(width: 8),
                          const Text('Tap on the map to place center point'),
                        ],
                      ),
                    ),
                  if (_center != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green[700]),
                          const SizedBox(width: 8),
                          Text(
                            'Center: ${_center!.latitude.toStringAsFixed(4)}, ${_center!.longitude.toStringAsFixed(4)}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Name field
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Geofence Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.label_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Radius slider
                  Row(
                    children: [
                      const Text(
                        'Radius',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${_radius.toInt()} m',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _radius,
                    min: AppConstants.minGeofenceRadius,
                    max: AppConstants.maxGeofenceRadius,
                    divisions: 39, // (1000-25)/25 = 39
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        _radius = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  // Color selection
                  const Text(
                    'Color',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: AppConstants.geofenceColors.map((colorInt) {
                      final isSelected = colorInt == _selectedColor;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = colorInt;
                          });
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Color(colorInt),
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: Colors.black87,
                                    width: 3,
                                  )
                                : Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 20)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Geofence',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
