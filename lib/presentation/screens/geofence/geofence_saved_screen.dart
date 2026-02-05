import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/geofence_provider.dart';
import '../../widgets/geofence/geofence_list_item.dart';

class GeofenceSavedScreen extends ConsumerWidget {
  const GeofenceSavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unassignedAsync = ref.watch(unassignedGeofencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add from Saved'),
      ),
      body: unassignedAsync.when(
        data: (geofences) {
          if (geofences.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    'All geofences are already assigned',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Draw a new one to create more',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: geofences.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final geofence = geofences[index];
              return GeofenceListItem(
                geofence: geofence,
                onTap: () async {
                  await ref
                      .read(selectedPetGeofencesProvider.notifier)
                      .assignExisting(geofence.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${geofence.name} added'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    context.pop();
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
