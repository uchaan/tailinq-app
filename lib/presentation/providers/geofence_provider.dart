import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/geofence.dart';
import '../../data/models/pet_geofence.dart';
import '../../data/repositories/mock_geofence_repository.dart';
import 'pet_provider.dart';

const _uuid = Uuid();

/// Repository provider
final geofenceRepositoryProvider = Provider<MockGeofenceRepository>((ref) {
  return MockGeofenceRepository();
});

/// Toggle for showing geofence circles on the map
final showGeofencesProvider = StateProvider<bool>((ref) => true);

/// Manages the list of geofences assigned to the currently selected pet
final selectedPetGeofencesProvider =
    StateNotifierProvider<PetGeofenceNotifier, AsyncValue<List<Geofence>>>(
        (ref) {
  final repository = ref.watch(geofenceRepositoryProvider);
  final petId = ref.watch(selectedPetIdProvider);
  return PetGeofenceNotifier(repository, petId);
});

class PetGeofenceNotifier extends StateNotifier<AsyncValue<List<Geofence>>> {
  final MockGeofenceRepository _repository;
  final String? _petId;

  PetGeofenceNotifier(this._repository, this._petId)
      : super(const AsyncValue.loading()) {
    loadGeofences();
  }

  Future<void> loadGeofences() async {
    if (_petId == null) {
      state = const AsyncValue.data([]);
      return;
    }
    try {
      final geofences = await _repository.getGeofencesForPet(_petId);
      state = AsyncValue.data(geofences);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Create a new geofence and assign it to the current pet
  Future<void> createAndAssign({
    required String name,
    required double latitude,
    required double longitude,
    required double radiusMeters,
    required int color,
  }) async {
    if (_petId == null) return;
    final geofence = Geofence(
      id: _uuid.v4(),
      name: name,
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radiusMeters,
      color: color,
    );
    await _repository.createGeofence(geofence);

    final assignment = PetGeofence(
      id: _uuid.v4(),
      petId: _petId,
      geofenceId: geofence.id,
      assignedAt: DateTime.now(),
    );
    await _repository.assignGeofenceToPet(assignment);
    await loadGeofences();
  }

  /// Assign an existing geofence to the current pet
  Future<void> assignExisting(String geofenceId) async {
    if (_petId == null) return;
    final assignment = PetGeofence(
      id: _uuid.v4(),
      petId: _petId,
      geofenceId: geofenceId,
      assignedAt: DateTime.now(),
    );
    await _repository.assignGeofenceToPet(assignment);
    await loadGeofences();
  }

  /// Remove a geofence from the current pet (does not delete globally)
  Future<void> removeFromPet(String geofenceId) async {
    if (_petId == null) return;
    await _repository.removeGeofenceFromPet(_petId, geofenceId);
    await loadGeofences();
  }

  /// Delete a geofence globally (removes from all pets)
  Future<void> deleteGlobally(String geofenceId) async {
    await _repository.deleteGeofence(geofenceId);
    await loadGeofences();
  }
}

/// Provides the set of Circle overlays for the map
final geofenceCirclesProvider = Provider<Set<Circle>>((ref) {
  final show = ref.watch(showGeofencesProvider);
  if (!show) return {};

  final geofencesAsync = ref.watch(selectedPetGeofencesProvider);
  return geofencesAsync.when(
    data: (geofences) {
      return geofences.map((g) {
        final color = Color(g.color);
        return Circle(
          circleId: CircleId(g.id),
          center: LatLng(g.latitude, g.longitude),
          radius: g.radiusMeters,
          fillColor: color.withAlpha(38), // ~0.15 opacity
          strokeColor: color.withAlpha(153), // ~0.6 opacity
          strokeWidth: 2,
        );
      }).toSet();
    },
    loading: () => {},
    error: (_, __) => {},
  );
});

/// Provides geofences not yet assigned to the current pet
final unassignedGeofencesProvider = FutureProvider<List<Geofence>>((ref) async {
  final repository = ref.watch(geofenceRepositoryProvider);
  final petId = ref.watch(selectedPetIdProvider);
  if (petId == null) return [];

  final allGeofences = await repository.getAllGeofences();
  final petGeofences = await repository.getGeofencesForPet(petId);
  final assignedIds = petGeofences.map((g) => g.id).toSet();

  return allGeofences.where((g) => !assignedIds.contains(g.id)).toList();
});
