import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../data/models/pet.dart';
import 'pet_image_picker.dart';
import 'species_selector.dart';

class PetForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController breedController;
  final PetSpecies? selectedSpecies;
  final DateTime? selectedBirthDate;
  final String? currentImageUrl;
  final Uint8List? selectedImageBytes;
  final bool isLoading;
  final ValueChanged<PetSpecies> onSpeciesChanged;
  final ValueChanged<DateTime?> onBirthDateChanged;
  final ValueChanged<Uint8List?> onImageSelected;
  final VoidCallback onSubmit;
  final String submitButtonText;
  final Widget? bottomContent;

  const PetForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.breedController,
    required this.selectedSpecies,
    required this.selectedBirthDate,
    this.currentImageUrl,
    this.selectedImageBytes,
    required this.isLoading,
    required this.onSpeciesChanged,
    required this.onBirthDateChanged,
    required this.onImageSelected,
    required this.onSubmit,
    required this.submitButtonText,
    this.bottomContent,
  });

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedBirthDate ?? now,
      firstDate: DateTime(now.year - 30),
      lastDate: now,
    );
    if (picked != null) {
      onBirthDateChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: PetImagePicker(
                currentImageUrl: currentImageUrl,
                selectedImageBytes: selectedImageBytes,
                onImageSelected: onImageSelected,
              ),
            ),
            const SizedBox(height: 32),

            // Name field
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name *',
                hintText: "Enter pet's name",
                border: OutlineInputBorder(),
              ),
              enabled: !isLoading,
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Species selector
            const Text(
              'Species *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            SpeciesSelector(
              selected: selectedSpecies,
              onChanged: onSpeciesChanged,
            ),
            const SizedBox(height: 24),

            // Breed field
            TextFormField(
              controller: breedController,
              decoration: const InputDecoration(
                labelText: 'Breed',
                hintText: 'Enter breed (optional)',
                border: OutlineInputBorder(),
              ),
              enabled: !isLoading,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 24),

            // Birth date picker
            const Text(
              'Birth Date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: isLoading ? null : () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  selectedBirthDate != null
                      ? _formatDate(selectedBirthDate!)
                      : 'Select date (optional)',
                  style: TextStyle(
                    color: selectedBirthDate != null
                        ? Colors.black
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),
            if (bottomContent != null) ...[
              const SizedBox(height: 32),
              bottomContent!,
            ],
            const SizedBox(height: 32),

            // Submit button
            FilledButton(
              onPressed: isLoading ? null : onSubmit,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      submitButtonText,
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
