import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/pet.dart';
import '../../providers/health_provider.dart';
import '../../providers/pet_provider.dart';
import '../../widgets/activity/health_metric_card.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPetAsync = ref.watch(selectedPetProvider);
    final healthMetricsAsync = ref.watch(healthMetricsProvider);

    final petName = selectedPetAsync.valueOrNull?.name ?? 'Pet';

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => _showPetSwitcher(context, ref),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$petName's Health",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: healthMetricsAsync.when(
        data: (metrics) {
          if (metrics.isEmpty) {
            return const Center(child: Text('No health data available'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: metrics.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return HealthMetricCard(metric: metrics[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Error loading health data: $error'),
        ),
      ),
    );
  }

  void _showPetSwitcher(BuildContext context, WidgetRef ref) {
    final petsState = ref.read(petNotifierProvider);

    petsState.whenData((pets) {
      if (pets.isEmpty) return;

      final currentPetId = ref.read(selectedPetIdProvider);

      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => _PetSwitcherSheet(
          pets: pets,
          currentPetId: currentPetId,
        ),
      );
    });
  }
}

class _PetSwitcherSheet extends ConsumerWidget {
  final List<Pet> pets;
  final String? currentPetId;

  const _PetSwitcherSheet({
    required this.pets,
    this.currentPetId,
  });

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

  Uint8List? _decodeDataUrl(String dataUrl) {
    try {
      final base64String = dataUrl.split(',').last;
      return base64Decode(base64String);
    } catch (e) {
      return null;
    }
  }

  Widget _buildAvatar(Pet pet) {
    if (pet.imageUrl != null) {
      if (pet.imageUrl!.startsWith('data:')) {
        final bytes = _decodeDataUrl(pet.imageUrl!);
        if (bytes != null) {
          return CircleAvatar(
            radius: 24,
            backgroundImage: MemoryImage(bytes),
          );
        }
      } else if (pet.imageUrl!.startsWith('http')) {
        return CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(pet.imageUrl!),
        );
      }
    }

    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.grey[200],
      child: Text(
        _getSpeciesEmoji(pet.species),
        style: const TextStyle(fontSize: 22),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Switch Pet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              final isSelected = pet.id == currentPetId;

              return ListTile(
                leading: _buildAvatar(pet),
                title: Text(
                  pet.name,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  pet.breed ??
                      pet.species.name[0].toUpperCase() +
                          pet.species.name.substring(1),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle,
                        color: Theme.of(context).primaryColor)
                    : null,
                onTap: () {
                  ref.read(selectedPetIdProvider.notifier).state = pet.id;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Switched to ${pet.name}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
