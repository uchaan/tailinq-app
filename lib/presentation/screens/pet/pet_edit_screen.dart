import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/pet.dart';
import '../../providers/pet_provider.dart';
import '../../widgets/pet/pet_form.dart';

class PetEditScreen extends ConsumerStatefulWidget {
  final String petId;

  const PetEditScreen({super.key, required this.petId});

  @override
  ConsumerState<PetEditScreen> createState() => _PetEditScreenState();
}

class _PetEditScreenState extends ConsumerState<PetEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _breedController;

  Pet? _pet;
  PetSpecies? _selectedSpecies;
  DateTime? _selectedBirthDate;
  Uint8List? _selectedImageBytes;
  bool _imageRemoved = false;
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _breedController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  void _initializeForm(Pet pet) {
    if (_isInitialized) return;
    _pet = pet;
    _nameController.text = pet.name;
    _breedController.text = pet.breed ?? '';
    _selectedSpecies = pet.species;
    _selectedBirthDate = pet.birthDate;
    _isInitialized = true;
  }

  Future<void> _savePet() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pet == null) return;

    if (_selectedSpecies == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a species'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedPet = _pet!.copyWith(
        name: _nameController.text.trim(),
        species: _selectedSpecies!,
        breed: _breedController.text.trim().isEmpty
            ? null
            : _breedController.text.trim(),
        birthDate: _selectedBirthDate,
      );

      await ref.read(petNotifierProvider.notifier).updatePet(
            pet: updatedPet,
            newImageBytes: _selectedImageBytes,
            removeImage: _imageRemoved,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet updated successfully')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update pet: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deletePet() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pet'),
        content: Text('Are you sure you want to delete ${_pet?.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || _pet == null) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(petNotifierProvider.notifier).deletePet(_pet!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet deleted')),
        );
        context.go('/pets');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete pet: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final petsState = ref.watch(petNotifierProvider);

    return petsState.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Edit Pet')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Edit Pet')),
        body: Center(child: Text('Error: $error')),
      ),
      data: (pets) {
        final pet = pets.where((p) => p.id == widget.petId).firstOrNull;

        if (pet == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Edit Pet')),
            body: const Center(child: Text('Pet not found')),
          );
        }

        _initializeForm(pet);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Pet'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _isLoading ? null : _deletePet,
              ),
            ],
          ),
          body: PetForm(
            formKey: _formKey,
            nameController: _nameController,
            breedController: _breedController,
            selectedSpecies: _selectedSpecies,
            selectedBirthDate: _selectedBirthDate,
            currentImageUrl: _imageRemoved ? null : pet.imageUrl,
            selectedImageBytes: _selectedImageBytes,
            isLoading: _isLoading,
            onSpeciesChanged: (species) =>
                setState(() => _selectedSpecies = species),
            onBirthDateChanged: (date) =>
                setState(() => _selectedBirthDate = date),
            onImageSelected: (bytes) {
              setState(() {
                _selectedImageBytes = bytes;
                _imageRemoved = bytes == null;
              });
            },
            onSubmit: _savePet,
            submitButtonText: 'Save Changes',
          ),
        );
      },
    );
  }
}
