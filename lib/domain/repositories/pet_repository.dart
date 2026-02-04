import '../../data/models/pet.dart';
import '../../data/models/pet_member.dart';

abstract class PetRepository {
  Future<List<Pet>> getPets();
  Future<Pet?> getPet(String id);
  Future<Pet> createPet(Pet pet);
  Future<Pet> updatePet(Pet pet);
  Future<void> deletePet(String id);

  Future<List<PetMember>> getPetMembers(String petId);
  Future<PetMember> addPetMember(PetMember member);
  Future<void> removePetMember(String memberId);
  Future<PetMember> updatePetMemberRole(String memberId, PetMemberRole role);
}
