import '../models/pet.dart';
import '../models/pet_member.dart';
import '../../domain/repositories/pet_repository.dart';

class MockPetRepository implements PetRepository {
  final Map<String, Pet> _pets = {};
  final Map<String, PetMember> _members = {};

  MockPetRepository() {
    _initMockData();
  }

  void _initMockData() {
    // Mock pets
    final pets = [
      Pet(
        id: 'pet-1',
        name: 'Max',
        species: PetSpecies.dog,
        breed: 'Golden Retriever',
        birthDate: DateTime(2020, 3, 15),
        deviceId: 'device-1',
        imageUrl: null,
      ),
      Pet(
        id: 'pet-2',
        name: 'Bella',
        species: PetSpecies.cat,
        breed: 'Persian',
        birthDate: DateTime(2021, 7, 22),
        deviceId: 'device-2',
        imageUrl: null,
      ),
    ];

    for (final pet in pets) {
      _pets[pet.id] = pet;
    }

    // Mock members (assuming current user id is 'user-1')
    final members = [
      PetMember(
        id: 'member-1',
        petId: 'pet-1',
        userId: 'user-1',
        role: PetMemberRole.owner,
        joinedAt: DateTime(2020, 3, 15),
      ),
      PetMember(
        id: 'member-2',
        petId: 'pet-2',
        userId: 'user-1',
        role: PetMemberRole.owner,
        joinedAt: DateTime(2021, 7, 22),
      ),
    ];

    for (final member in members) {
      _members[member.id] = member;
    }
  }

  @override
  Future<List<Pet>> getPets() async {
    return _pets.values.toList();
  }

  @override
  Future<Pet?> getPet(String id) async {
    return _pets[id];
  }

  @override
  Future<Pet> createPet(Pet pet) async {
    _pets[pet.id] = pet;
    return pet;
  }

  @override
  Future<Pet> updatePet(Pet pet) async {
    _pets[pet.id] = pet;
    return pet;
  }

  @override
  Future<void> deletePet(String id) async {
    _pets.remove(id);
    _members.removeWhere((_, member) => member.petId == id);
  }

  @override
  Future<List<PetMember>> getPetMembers(String petId) async {
    return _members.values.where((m) => m.petId == petId).toList();
  }

  @override
  Future<PetMember> addPetMember(PetMember member) async {
    _members[member.id] = member;
    return member;
  }

  @override
  Future<void> removePetMember(String memberId) async {
    _members.remove(memberId);
  }

  @override
  Future<PetMember> updatePetMemberRole(
      String memberId, PetMemberRole role) async {
    final member = _members[memberId];
    if (member == null) {
      throw Exception('Member not found');
    }
    final updatedMember = member.copyWith(role: role);
    _members[memberId] = updatedMember;
    return updatedMember;
  }
}
