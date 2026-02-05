import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/health_metric.dart';
import 'metric_config.dart';
import 'sparkline_chart.dart';

class HealthMetricCard extends StatelessWidget {
  final HealthMetric metric;

  const HealthMetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    final config = metricConfigs[metric.type]!;
    final isPositive = metric.changePercent >= 0;
    final trendArrow = isPositive ? '↑' : '↓';
    final trendColor = isPositive ? Colors.green : Colors.red;
    final formattedValue = _formatValue(metric.currentValue, metric.type);

    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => context.push('/activity/${metric.type.name}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              CircleAvatar(
                radius: 24,
                backgroundColor: config.color.withAlpha(30),
                child: Icon(config.icon, color: config.color, size: 24),
              ),
              const SizedBox(width: 16),
              // Metric info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          config.displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$trendArrow${metric.changePercent.abs()}%',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: trendColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$formattedValue ${metric.unit}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Sparkline
              SparklineChart(
                data: metric.dailyData.map((d) => d.value).toList(),
                color: config.color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatValue(double value, HealthMetricType type) {
    if (type == HealthMetricType.activity) {
      if (value >= 1000) {
        return '${(value / 1000).toStringAsFixed(1)}k';
      }
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(1);
  }
}
