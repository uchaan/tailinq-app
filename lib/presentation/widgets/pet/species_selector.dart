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
          value: PetSpecies.bird,
          label: Text('Bird'),
          icon: Icon(Icons.flutter_dash),
        ),
        ButtonSegment(
          value: PetSpecies.rabbit,
          label: Text('Rabbit'),
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
