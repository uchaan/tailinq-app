import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/route_provider.dart';

class RouteToggle extends ConsumerWidget {
  const RouteToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showRoute = ref.watch(showRouteProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.route, size: 18, color: Colors.blue[700]),
            const SizedBox(width: 8),
            const Text(
              'Show Route',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Switch(
          value: showRoute,
          onChanged: (value) {
            ref.read(showRouteProvider.notifier).state = value;
          },
          activeTrackColor: Colors.blue[200],
          thumbColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.blue;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
