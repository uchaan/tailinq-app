import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/geofence_provider.dart';

class GeofenceToggle extends ConsumerWidget {
  const GeofenceToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showGeofences = ref.watch(showGeofencesProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.fence, size: 18, color: Colors.green[700]),
                const SizedBox(width: 8),
                const Text(
                  'Show Geofences',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Switch(
              value: showGeofences,
              onChanged: (value) {
                ref.read(showGeofencesProvider.notifier).state = value;
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
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.go('/home/geofences'),
            icon: const Icon(Icons.map_outlined, size: 18),
            label: const Text('Manage Geofences'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green[700],
              side: BorderSide(color: Colors.green[300]!),
            ),
          ),
        ),
      ],
    );
  }
}
