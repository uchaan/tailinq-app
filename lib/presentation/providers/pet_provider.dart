import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/pet.dart';
import '../../data/models/pet_member.dart';
import '../../data/repositories/mock_pet_repository.dart';
import '../../domain/repositories/storage_repository.dart';
import 'storage_provider.dart';

final petRepositoryProvider = Provider<MockPetRepository>((ref) {
  return MockPetRepository();
});

final petsProvider = FutureProvider<List<Pet>>((ref) async {
  final repository = ref.watch(petRepositoryProvider);
  return repository.getPets();
});

final selectedPetIdProvider = StateProvider<String?>((ref) => 'pet-1');

final selectedPetProvider = FutureProvider<Pet?>((ref) async {
  final petId = ref.watch(selectedPetIdProvider);
  if (petId == null) return null;
  final repository = ref.watch(petRepositoryProvider);
  return repository.getPet(petId);
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
    state = const AsyncValue.loading();
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
