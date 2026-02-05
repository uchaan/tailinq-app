import '../../data/models/geofence.dart';
import '../../data/models/pet_geofence.dart';

abstract class GeofenceRepository {
  // Geofence CRUD
  Future<List<Geofence>> getAllGeofences();
  Future<Geofence?> getGeofence(String id);
  Future<Geofence> createGeofence(Geofence geofence);
  Future<Geofence> updateGeofence(Geofence geofence);
  Future<void> deleteGeofence(String id);

  // Pet-Geofence 연결
  Future<List<Geofence>> getGeofencesForPet(String petId);
  Future<PetGeofence> assignGeofenceToPet(PetGeofence assignment);
  Future<void> removeGeofenceFromPet(String petId, String geofenceId);
}
