import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/pet.dart';
import '../../providers/pet_provider.dart';

class PetDetailScreen extends ConsumerWidget {
  final String petId;

  const PetDetailScreen({super.key, required this.petId});

  String _getSpeciesEmoji(PetSpecies species) {
    switch (species) {
      case PetSpecies.dog:
        return '🐕';
      case PetSpecies.cat:
        return '🐱';
      case PetSpecies.bird:
        return '🐦';
      case PetSpecies.rabbit:
        return '🐰';
      case PetSpecies.other:
        return '🐾';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;

    if (months < 0 || (months == 0 && now.day < birthDate.day)) {
      years--;
      months += 12;
    }
    if (now.day < birthDate.day) {
      months--;
      if (months < 0) months += 12;
    }

    if (years > 0) {
      return '$years year${years > 1 ? 's' : ''}${months > 0 ? ', $months month${months > 1 ? 's' : ''}' : ''}';
    } else {
      return '$months month${months > 1 ? 's' : ''}';
    }
  }

  Uint8List? _decodeDataUrl(String dataUrl) {
    try {
      final base64String = dataUrl.split(',').last;
      return base64Decode(base64String);
    } catch (e) {
      return null;
    }
  }

  Widget _buildImage(Pet pet) {
    if (pet.imageUrl != null) {
      if (pet.imageUrl!.startsWith('data:')) {
        final bytes = _decodeDataUrl(pet.imageUrl!);
        if (bytes != null) {
          return Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(bytes),
                fit: BoxFit.cover,
              ),
            ),
          );
        }
      } else if (pet.imageUrl!.startsWith('http')) {
        return Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(pet.imageUrl!),
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    }

    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.grey[200],
      child: Center(
        child: Text(
          _getSpeciesEmoji(pet.species),
          style: const TextStyle(fontSize: 80),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsState = ref.watch(petNotifierProvider);
    final selectedPetId = ref.watch(selectedPetIdProvider);

    return petsState.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $error')),
      ),
      data: (pets) {
        final pet = pets.where((p) => p.id == petId).firstOrNull;

        if (pet == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Pet not found')),
          );
        }

        final isActivePet = pet.id == selectedPetId;

        return Scaffold(
          appBar: AppBar(
            title: Text(pet.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.push('/pets/${pet.id}/edit'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(pet),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              pet.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          if (isActivePet)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Active',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (pet.breed != null) ...[
                        Text(
                          pet.breed!,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (!isActivePet) ...[
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ref.read(selectedPetIdProvider.notifier).state =
                                  pet.id;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('${pet.name} is now active'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Set as Active Pet'),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      const Divider(),
                      const SizedBox(height: 16),
                      _InfoRow(
                        icon: Icons.category,
                        label: 'Species',
                        value:
                            '${_getSpeciesEmoji(pet.species)} ${pet.species.name[0].toUpperCase()}${pet.species.name.substring(1)}',
                      ),
                      if (pet.birthDate != null) ...[
                        const SizedBox(height: 16),
                        _InfoRow(
                          icon: Icons.cake,
                          label: 'Birth Date',
                          value: _formatDate(pet.birthDate!),
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(
                          icon: Icons.schedule,
                          label: 'Age',
                          value: _calculateAge(pet.birthDate!),
                        ),
                      ],
                      if (pet.deviceId != null) ...[
                        const SizedBox(height: 16),
                        _InfoRow(
                          icon: Icons.bluetooth,
                          label: 'Device',
                          value: 'Connected',
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
