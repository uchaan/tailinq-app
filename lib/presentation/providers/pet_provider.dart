import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/pet.dart';
import '../../data/models/pet_member.dart';
import '../../data/repositories/mock_pet_repository.dart';
import '../../domain/repositories/pet_repository.dart';
import '../../domain/repositories/storage_repository.dart';
import 'auth_provider.dart';
import 'storage_provider.dart';

final petRepositoryProvider = Provider<MockPetRepository>((ref) {
  final user = ref.watch(currentUserProvider);
  return MockPetRepository(
    currentUserId: user?.id ?? 'user-1',
    currentUserName: user?.name ?? user?.email ?? 'Me',
    currentUserEmail: user?.email ?? 'me@example.com',
  );
});

final petsProvider = FutureProvider<List<Pet>>((ref) async {
  final repository = ref.watch(petRepositoryProvider);
  return repository.getPets();
});

final selectedPetIdProvider = StateProvider<String?>((ref) => 'pet-1');

final selectedPetProvider = Provider<AsyncValue<Pet?>>((ref) {
  final petId = ref.watch(selectedPetIdProvider);
  if (petId == null) return const AsyncValue.data(null);

  final petsState = ref.watch(petNotifierProvider);
  return petsState.whenData(
    (pets) => pets.where((p) => p.id == petId).firstOrNull,
  );
});

final petMembersProvider =
    FutureProvider.family<List<PetMember>, String>((ref, petId) async {
  final repository = ref.watch(petRepositoryProvider);
  return repository.getPetMembers(petId);
});

final petNotifierProvider =
    StateNotifierProvider<PetNotifier, AsyncValue<List<Pet>>>((ref) {
  final repository = ref.watch(petRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PetNotifier(repository, storageRepository);
});

class PetNotifier extends StateNotifier<AsyncValue<List<Pet>>> {
  final MockPetRepository _repository;
  final StorageRepository _storageRepository;
  final _uuid = const Uuid();

  PetNotifier(this._repository, this._storageRepository)
      : super(const AsyncValue.loading()) {
    loadPets();
  }

  Future<void> loadPets() async {
    try {
      final pets = await _repository.getPets();
      state = AsyncValue.data(pets);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<Pet> createPet({
    required String name,
    required PetSpecies species,
    String? breed,
    DateTime? birthDate,
    Uint8List? imageBytes,
  }) async {
    String? imageUrl;

    if (imageBytes != null) {
      final fileName = 'pets/${_uuid.v4()}.jpg';
      imageUrl = await _storageRepository.uploadImage(
        bytes: imageBytes,
        fileName: fileName,
      );
    }

    final pet = Pet(
      id: _uuid.v4(),
      name: name,
      species: species,
      breed: breed,
      birthDate: birthDate,
      imageUrl: imageUrl,
    );

    final createdPet = await _repository.createPet(pet);
    await loadPets();
    return createdPet;
  }

  Future<Pet> updatePet({
    required Pet pet,
    Uint8List? newImageBytes,
    bool removeImage = false,
  }) async {
    var updatedPet = pet;

    if (removeImage) {
      if (pet.imageUrl != null) {
        await _storageRepository.deleteImage(pet.imageUrl!);
      }
      updatedPet = pet.copyWith(imageUrl: null);
    } else if (newImageBytes != null) {
      // Delete old image if exists
      if (pet.imageUrl != null) {
        await _storageRepository.deleteImage(pet.imageUrl!);
      }

      // Upload new image
      final fileName = 'pets/${_uuid.v4()}.jpg';
      final imageUrl = await _storageRepository.uploadImage(
        bytes: newImageBytes,
        fileName: fileName,
      );
      updatedPet = pet.copyWith(imageUrl: imageUrl);
    }

    final result = await _repository.updatePet(updatedPet);
    await loadPets();
    return result;
  }

  Future<void> deletePet(String id) async {
    final pet = await _repository.getPet(id);
    if (pet?.imageUrl != null) {
      await _storageRepository.deleteImage(pet!.imageUrl!);
    }
    await _repository.deletePet(id);
    await loadPets();
  }
}

final petMemberNotifierProvider = StateNotifierProvider
    .family<PetMemberNotifier, AsyncValue<List<PetMember>>, String>(
  (ref, petId) {
    final repository = ref.watch(petRepositoryProvider);
    return PetMemberNotifier(repository, petId);
  },
);

class PetMemberNotifier extends StateNotifier<AsyncValue<List<PetMember>>> {
  final PetRepository _repository;
  final String _petId;
  final _uuid = const Uuid();

  PetMemberNotifier(this._repository, this._petId)
      : super(const AsyncValue.loading()) {
    loadMembers();
  }

  Future<void> loadMembers() async {
    state = const AsyncValue.loading();
    try {
      final members = await _repository.getPetMembers(_petId);
      state = AsyncValue.data(members);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addMember({
    required String email,
    required String name,
    PetMemberRole role = PetMemberRole.family,
  }) async {
    try {
      final member = PetMember(
        id: _uuid.v4(),
        petId: _petId,
        userId: _uuid.v4(),
        role: role,
        userName: name,
        userEmail: email,
        joinedAt: DateTime.now(),
      );
      await _repository.addPetMember(member);
      await loadMembers();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeMember(String memberId) async {
    try {
      await _repository.removePetMember(memberId);
      await loadMembers();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> transferPrimary(String newPrimaryMemberId) async {
    try {
      await _repository.transferPrimary(_petId, newPrimaryMemberId);
      await loadMembers();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
