import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/device.dart';
import '../../data/models/pet.dart';
import '../providers/device_provider.dart';
import '../providers/pet_provider.dart';
import 'blinking_live_badge.dart';
import 'route_toggle.dart';
import 'simulation_control_panel.dart';

class DeviceBottomSheet extends ConsumerStatefulWidget {
  final Device device;
  final Pet? pet;

  const DeviceBottomSheet({super.key, required this.device, this.pet});

  @override
  ConsumerState<DeviceBottomSheet> createState() => _DeviceBottomSheetState();
}

class _DeviceBottomSheetState extends ConsumerState<DeviceBottomSheet> {
  double _dragDelta = 0;

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

  Widget _buildPetAvatar(Pet? pet) {
    if (pet?.imageUrl != null) {
      if (pet!.imageUrl!.startsWith('data:')) {
        final bytes = _decodeDataUrl(pet.imageUrl!);
        if (bytes != null) {
          return CircleAvatar(
            radius: 30,
            backgroundImage: MemoryImage(bytes),
          );
        }
      } else if (pet.imageUrl!.startsWith('http')) {
        return CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(pet.imageUrl!),
          onBackgroundImageError: (exception, stackTrace) {},
          child: null,
        );
      }
    }

    // Default avatar with species emoji
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey[200],
      child: Text(
        pet != null ? _getSpeciesEmoji(pet.species) : '🐾',
        style: const TextStyle(fontSize: 28),
      ),
    );
  }

  void _showPetSwitcher(BuildContext context, WidgetRef ref) {
    final petsState = ref.read(petNotifierProvider);
    final currentPetId = ref.read(selectedPetIdProvider);

    petsState.whenData((pets) {
      if (pets.isEmpty) return;

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

  @override
  Widget build(BuildContext context) {
    final isLiveMode = ref.watch(isLiveModeProvider);
    final isExpanded = ref.watch(bottomSheetExpandedProvider);
    // Watch pet provider directly to ensure photo updates are reflected immediately
    final currentPet = ref.watch(selectedPetProvider).valueOrNull ?? widget.pet;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  _dragDelta += details.delta.dy;
                },
                onVerticalDragEnd: (details) {
                  if (_dragDelta > 50) {
                    ref.read(bottomSheetExpandedProvider.notifier).state = false;
                  } else if (_dragDelta < -50) {
                    ref.read(bottomSheetExpandedProvider.notifier).state = true;
                  }
                  _dragDelta = 0;
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              // Pet info row (always visible)
              InkWell(
                onTap: () => _showPetSwitcher(context, ref),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      _buildPetAvatar(currentPet),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  currentPet?.name ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.swap_horiz,
                                  size: 18,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 8),
                                if (isLiveMode) const BlinkingLiveBadge(),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  _getBatteryIcon(widget.device.batteryLevel),
                                  size: 16,
                                  color: _getBatteryColor(widget.device.batteryLevel),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.device.batteryLevel}%',
                                  style: TextStyle(
                                    color: _getBatteryColor(widget.device.batteryLevel),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _getStatusColor(widget.device.status),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _getStatusText(widget.device.status),
                                  style: TextStyle(
                                    color: _getStatusColor(widget.device.status),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Expandable content
              if (isExpanded) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.gps_fixed, size: 18, color: Colors.green[700]),
                        const SizedBox(width: 8),
                        const Text(
                          'Live Tracking',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isLiveMode && widget.device.lastLocation != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            _formatTimestamp(widget.device.lastLocation!.timestamp),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Switch(
                      value: isLiveMode,
                      onChanged: (value) {
                        ref.read(isLiveModeProvider.notifier).toggle();
                      },
                      activeTrackColor: Colors.green[200],
                      thumbColor: WidgetStateProperty.resolveWith<Color?>(
                        (states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.green;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const RouteToggle(),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                const SimulationControlPanel(),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getBatteryIcon(int level) {
    if (level > 80) return Icons.battery_full;
    if (level > 50) return Icons.battery_5_bar;
    if (level > 20) return Icons.battery_3_bar;
    return Icons.battery_1_bar;
  }

  Color _getBatteryColor(int level) {
    if (level > 50) return Colors.green;
    if (level > 20) return Colors.orange;
    return Colors.red;
  }

  Color _getStatusColor(DeviceStatus status) {
    switch (status) {
      case DeviceStatus.online:
        return Colors.green;
      case DeviceStatus.offline:
        return Colors.grey;
      case DeviceStatus.lowBattery:
        return Colors.orange;
    }
  }

  String _getStatusText(DeviceStatus status) {
    switch (status) {
      case DeviceStatus.online:
        return 'Online';
      case DeviceStatus.offline:
        return 'Offline';
      case DeviceStatus.lowBattery:
        return 'Low Battery';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
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
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  pet.breed ?? pet.species.name[0].toUpperCase() + pet.species.name.substring(1),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
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
