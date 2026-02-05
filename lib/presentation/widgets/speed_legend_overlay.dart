import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/route_provider.dart';
import '../utils/polyline_builder.dart';

class SpeedLegendOverlay extends ConsumerWidget {
  const SpeedLegendOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showRoute = ref.watch(showRouteProvider);
    if (!showRoute) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(230),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Speed',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          _legendRow(SpeedCategory.stationary, '< 0.5 m/s'),
          const SizedBox(height: 3),
          _legendRow(SpeedCategory.walking, '0.5–1.5 m/s'),
          const SizedBox(height: 3),
          _legendRow(SpeedCategory.jogging, '1.5–3.0 m/s'),
          const SizedBox(height: 3),
          _legendRow(SpeedCategory.running, '> 3.0 m/s'),
        ],
      ),
    );
  }

  Widget _legendRow(SpeedCategory category, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 3,
          color: speedCategoryColor(category),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }
}
