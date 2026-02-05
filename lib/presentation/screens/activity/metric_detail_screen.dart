import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/health_metric.dart';
import '../../providers/health_provider.dart';
import '../../widgets/activity/detail_line_chart.dart';
import '../../widgets/activity/metric_config.dart';

class MetricDetailScreen extends ConsumerWidget {
  final HealthMetricType metricType;

  const MetricDetailScreen({super.key, required this.metricType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricAsync = ref.watch(healthMetricDetailProvider(metricType));
    final config = metricConfigs[metricType]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(config.displayName),
      ),
      body: metricAsync.when(
        data: (metric) {
          if (metric == null) {
            return const Center(child: Text('No data available'));
          }
          return _buildContent(context, metric, config);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Error loading data: $error'),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    HealthMetric metric,
    MetricConfig config,
  ) {
    final isPositive = metric.changePercent >= 0;
    final trendArrow = isPositive ? '↑' : '↓';
    final trendColor = isPositive ? Colors.green : Colors.red;
    final formattedValue = _formatValue(metric.currentValue, metric.type);

    final values = metric.dailyData.map((d) => d.value).toList();
    final avg = values.reduce((a, b) => a + b) / values.length;
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero section
          _buildHeroSection(
            config: config,
            formattedValue: formattedValue,
            unit: metric.unit,
            trendArrow: trendArrow,
            trendColor: trendColor,
            changePercent: metric.changePercent,
          ),
          const SizedBox(height: 24),

          // Chart section
          _buildChartSection(metric, config),
          const SizedBox(height: 24),

          // Stats section
          _buildStatsSection(avg, min, max, metric.type),
          const SizedBox(height: 24),

          // Daily breakdown
          _buildDailyBreakdown(context, metric, config, max),
        ],
      ),
    );
  }

  Widget _buildHeroSection({
    required MetricConfig config,
    required String formattedValue,
    required String unit,
    required String trendArrow,
    required Color trendColor,
    required double changePercent,
  }) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: config.color.withAlpha(30),
            child: Icon(config.icon, color: config.color, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            config.displayName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$formattedValue $unit',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$trendArrow ${changePercent.abs()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: trendColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'vs previous avg',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(HealthMetric metric, MetricConfig config) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Last 30 Days',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            DetailLineChart(
              data: metric.dailyData,
              color: config.color,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(
    double avg,
    double min,
    double max,
    HealthMetricType type,
  ) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Avg',
            value: _formatValue(avg, type),
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            label: 'Min',
            value: _formatValue(min, type),
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            label: 'Max',
            value: _formatValue(max, type),
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyBreakdown(
    BuildContext context,
    HealthMetric metric,
    MetricConfig config,
    double maxValue,
  ) {
    final recentDays = metric.dailyData.reversed.take(10).toList();
    final today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Breakdown',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                for (int i = 0; i < recentDays.length; i++) ...[
                  _buildDayRow(
                    recentDays[i],
                    config,
                    maxValue,
                    _isToday(recentDays[i].date, today),
                  ),
                  if (i < recentDays.length - 1)
                    const Divider(height: 1, indent: 16, endIndent: 16),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayRow(
    DailyDataPoint day,
    MetricConfig config,
    double maxValue,
    bool isToday,
  ) {
    final label = isToday ? 'Today' : _formatDateLabel(day.date);
    final formattedValue = _formatValue(day.value, metricType);
    final barFraction = maxValue > 0 ? day.value / maxValue : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                color: isToday ? Colors.black : Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: barFraction.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: config.color.withAlpha(20),
                valueColor: AlwaysStoppedAnimation(config.color.withAlpha(150)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 56,
            child: Text(
              formattedValue,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isToday ? Colors.black : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date, DateTime today) {
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDateLabel(DateTime date) {
    return '${_months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}';
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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
