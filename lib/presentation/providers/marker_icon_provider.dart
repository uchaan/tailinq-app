import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/models/pet.dart';
import '../utils/marker_icon_generator.dart';
import 'device_provider.dart';
import 'pet_provider.dart';
import 'simulation_provider.dart';

String _speciesEmoji(PetSpecies species) {
  switch (species) {
    case PetSpecies.dog:
      return '\u{1F415}'; // 🐕
    case PetSpecies.cat:
      return '\u{1F431}'; // 🐱
    case PetSpecies.bird:
      return '\u{1F426}'; // 🐦
    case PetSpecies.rabbit:
      return '\u{1F430}'; // 🐰
    case PetSpecies.other:
      return '\u{1F43E}'; // 🐾
  }
}

/// Provider that generates a custom circular marker icon for the selected pet.
///
/// Rebuilds only when the pet, live mode, or simulation state changes —
/// NOT on every location update.
final petMarkerIconProvider = FutureProvider<BitmapDescriptor>((ref) async {
  final pet = ref.watch(selectedPetProvider).valueOrNull;
  final isLiveMode = ref.watch(isLiveModeProvider);
  final simState = ref.watch(simulationProvider);

  // Determine border color based on mode
  final Color borderColor;
  if (simState.isEnabled && simState.isRunning) {
    borderColor = Colors.orange;
  } else if (isLiveMode) {
    borderColor = Colors.red;
  } else {
    borderColor = Colors.green;
  }

  // Resolve image bytes from pet's imageUrl
  final imageBytes = _decodeImageUrl(pet?.imageUrl);

  // Fallback text (species emoji)
  final fallbackText = _speciesEmoji(pet?.species ?? PetSpecies.other);

  return generatePetMarkerIcon(
    imageBytes: imageBytes,
    fallbackText: fallbackText,
    borderColor: borderColor,
  );
});

/// Decode a data URL to bytes. Returns null for network URLs or null input.
Uint8List? _decodeImageUrl(String? imageUrl) {
  if (imageUrl == null) return null;

  if (imageUrl.startsWith('data:')) {
    try {
      final base64String = imageUrl.split(',').last;
      return base64Decode(base64String);
    } catch (_) {
      return null;
    }
  }

  // For network URLs we would need an HTTP fetch, but mock storage
  // always returns data URLs, so this path is currently unused.
  return null;
}
