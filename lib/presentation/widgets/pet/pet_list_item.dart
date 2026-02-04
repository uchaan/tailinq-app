import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../data/models/pet.dart';

class PetListItem extends StatelessWidget {
  final Pet pet;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onSelect;

  const PetListItem({
    super.key,
    required this.pet,
    this.isSelected = false,
    required this.onTap,
    this.onSelect,
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

  Widget _buildAvatar() {
    if (pet.imageUrl != null) {
      if (pet.imageUrl!.startsWith('data:')) {
        final bytes = _decodeDataUrl(pet.imageUrl!);
        if (bytes != null) {
          return CircleAvatar(
            radius: 28,
            backgroundImage: MemoryImage(bytes),
          );
        }
      } else if (pet.imageUrl!.startsWith('http')) {
        return CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(pet.imageUrl!),
        );
      }
    }

    return CircleAvatar(
      radius: 28,
      backgroundColor: Colors.grey[200],
      child: Text(
        _getSpeciesEmoji(pet.species),
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          _buildAvatar(),
          if (isSelected)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      title: Text(
        pet.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        pet.breed ?? pet.species.name[0].toUpperCase() + pet.species.name.substring(1),
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onSelect != null)
            IconButton(
              icon: Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              ),
              onPressed: onSelect,
              tooltip: 'Set as active pet',
            ),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
      onTap: onTap,
    );
  }
}
