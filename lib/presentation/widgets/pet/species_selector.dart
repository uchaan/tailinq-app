import 'package:flutter/material.dart';

import '../../../data/models/pet.dart';

class SpeciesSelector extends StatelessWidget {
  final PetSpecies? selected;
  final ValueChanged<PetSpecies> onChanged;

  const SpeciesSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<PetSpecies>(
      segments: const [
        ButtonSegment(
          value: PetSpecies.dog,
          label: Text('Dog'),
          icon: Icon(Icons.pets),
        ),
        ButtonSegment(
          value: PetSpecies.cat,
          label: Text('Cat'),
          icon: Icon(Icons.pets),
        ),
        ButtonSegment(
          value: PetSpecies.other,
          label: Text('Other'),
          icon: Icon(Icons.cruelty_free),
        ),
      ],
      selected: selected != null ? {selected!} : {},
      onSelectionChanged: (selection) {
        if (selection.isNotEmpty) {
          onChanged(selection.first);
        }
      },
      showSelectedIcon: false,
    );
  }
}
