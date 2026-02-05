import '../../domain/repositories/geofence_repository.dart';
import '../models/geofence.dart';
import '../models/pet_geofence.dart';

class MockGeofenceRepository implements GeofenceRepository {
  final Map<String, Geofence> _geofences = {};
  final Map<String, PetGeofence> _petGeofences = {};

  @override
  Future<List<Geofence>> getAllGeofences() async {
    return _geofences.values.toList();
  }

  @override
  Future<Geofence?> getGeofence(String id) async {
    return _geofences[id];
  }

  @override
  Future<Geofence> createGeofence(Geofence geofence) async {
    _geofences[geofence.id] = geofence;
    return geofence;
  }

  @override
  Future<Geofence> updateGeofence(Geofence geofence) async {
    _geofences[geofence.id] = geofence;
    return geofence;
  }

  @override
  Future<void> deleteGeofence(String id) async {
    _geofences.remove(id);
    // Cascade: remove all pet-geofence assignments for this geofence
    _petGeofences.removeWhere((_, pg) => pg.geofenceId == id);
  }

  @override
  Future<List<Geofence>> getGeofencesForPet(String petId) async {
    final geofenceIds = _petGeofences.values
        .where((pg) => pg.petId == petId)
        .map((pg) => pg.geofenceId)
        .toSet();

    return _geofences.values
        .where((g) => geofenceIds.contains(g.id))
        .toList();
  }

  @override
  Future<PetGeofence> assignGeofenceToPet(PetGeofence assignment) async {
    _petGeofences[assignment.id] = assignment;
    return assignment;
  }

  @override
  Future<void> removeGeofenceFromPet(String petId, String geofenceId) async {
    _petGeofences.removeWhere(
      (_, pg) => pg.petId == petId && pg.geofenceId == geofenceId,
    );
  }
}
