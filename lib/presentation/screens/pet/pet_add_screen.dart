import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/pet.dart';
import '../../providers/pet_provider.dart';
import '../../widgets/pet/pet_form.dart';

class PetAddScreen extends ConsumerStatefulWidget {
  const PetAddScreen({super.key});

  @override
  ConsumerState<PetAddScreen> createState() => _PetAddScreenState();
}

class _PetAddScreenState extends ConsumerState<PetAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();

  PetSpecies? _selectedSpecies;
  DateTime? _selectedBirthDate;
  Uint8List? _selectedImageBytes;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  Future<void> _savePet() async {
    if (!_formKey.currentState!.validate()) return;

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
      await ref.read(petNotifierProvider.notifier).createPet(
            name: _nameController.text.trim(),
            species: _selectedSpecies!,
            breed: _breedController.text.trim().isEmpty
                ? null
                : _breedController.text.trim(),
            birthDate: _selectedBirthDate,
            imageBytes: _selectedImageBytes,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet added successfully')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add pet: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pet'),
      ),
      body: PetForm(
        formKey: _formKey,
        nameController: _nameController,
        breedController: _breedController,
        selectedSpecies: _selectedSpecies,
        selectedBirthDate: _selectedBirthDate,
        selectedImageBytes: _selectedImageBytes,
        isLoading: _isLoading,
        onSpeciesChanged: (species) =>
            setState(() => _selectedSpecies = species),
        onBirthDateChanged: (date) =>
            setState(() => _selectedBirthDate = date),
        onImageSelected: (bytes) =>
            setState(() => _selectedImageBytes = bytes),
        onSubmit: _savePet,
        submitButtonText: 'Save Pet',
      ),
    );
  }
}
