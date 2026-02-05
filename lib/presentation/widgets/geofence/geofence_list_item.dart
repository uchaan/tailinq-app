import 'package:flutter/material.dart';

import '../../../data/models/geofence.dart';

class GeofenceListItem extends StatelessWidget {
  final Geofence geofence;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  const GeofenceListItem({
    super.key,
    required this.geofence,
    this.onRemove,
    this.onTap,
  });

  String _formatRadius(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '${meters.toInt()} m';
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(geofence.color);

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withAlpha(38),
        child: Icon(Icons.fence, color: color, size: 20),
      ),
      title: Text(
        geofence.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(_formatRadius(geofence.radiusMeters)),
      trailing: onRemove != null
          ? IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: onRemove,
            )
          : null,
    );
  }
}
