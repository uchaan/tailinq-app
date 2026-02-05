import 'package:flutter/material.dart';

import '../../../data/models/health_metric.dart';

typedef MetricConfig = ({String displayName, IconData icon, Color color});

const metricConfigs = {
  HealthMetricType.activity: (
    displayName: 'Activity',
    icon: Icons.directions_walk,
    color: Colors.blue,
  ),
  HealthMetricType.rest: (
    displayName: 'Rest',
    icon: Icons.bedtime,
    color: Colors.indigo,
  ),
  HealthMetricType.eating: (
    displayName: 'Eating',
    icon: Icons.restaurant,
    color: Colors.orange,
  ),
  HealthMetricType.drinking: (
    displayName: 'Drinking',
    icon: Icons.water_drop,
    color: Colors.cyan,
  ),
};
