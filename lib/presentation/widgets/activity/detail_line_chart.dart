import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../data/models/health_metric.dart';

class DetailLineChart extends StatelessWidget {
  final List<DailyDataPoint> data;
  final Color color;
  final double height;

  const DetailLineChart({
    super.key,
    required this.data,
    required this.color,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        size: Size.infinite,
        painter: _DetailLinePainter(
          data: data,
          color: color,
          textColor: Theme.of(context).textTheme.bodySmall?.color ??
              Colors.grey[600]!,
        ),
      ),
    );
  }
}

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _formatDate(DateTime date) {
  return '${_months[date.month - 1]} ${date.day}';
}

class _DetailLinePainter extends CustomPainter {
  final List<DailyDataPoint> data;
  final Color color;
  final Color textColor;

  static const double _leftPadding = 48;
  static const double _rightPadding = 12;
  static const double _topPadding = 8;
  static const double _bottomPadding = 24;

  _DetailLinePainter({
    required this.data,
    required this.color,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final chartLeft = _leftPadding;
    final chartRight = size.width - _rightPadding;
    final chartTop = _topPadding;
    final chartBottom = size.height - _bottomPadding;
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - chartTop;

    final values = data.map((d) => d.value).toList();
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final range = maxVal - minVal;
    final effectiveRange = range == 0 ? 1.0 : range;
    final padding = effectiveRange * 0.1;
    final yMin = minVal - padding;
    final yMax = maxVal + padding;
    final yRange = yMax - yMin;

    // Draw horizontal grid lines and Y-axis labels
    const gridLineCount = 4;
    final gridPaint = Paint()
      ..color = Colors.grey.withAlpha(40)
      ..strokeWidth = 1;

    for (int i = 0; i <= gridLineCount; i++) {
      final fraction = i / gridLineCount;
      final y = chartBottom - fraction * chartHeight;
      final value = yMin + fraction * yRange;

      canvas.drawLine(
        Offset(chartLeft, y),
        Offset(chartRight, y),
        gridPaint,
      );

      // Y-axis label
      final label = _formatAxisValue(value);
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(color: textColor, fontSize: 10),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(chartLeft - tp.width - 6, y - tp.height / 2));
    }

    // Build data points
    final stepX = chartWidth / (data.length - 1);
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = chartLeft + i * stepX;
      final y = chartBottom - ((data[i].value - yMin) / yRange) * chartHeight;
      points.add(Offset(x, y));
    }

    // Draw gradient fill
    final fillPath = Path()..moveTo(points.first.dx, chartBottom);
    for (final p in points) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.lineTo(points.last.dx, chartBottom);
    fillPath.close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [color.withAlpha(60), color.withAlpha(5)],
    );
    final fillPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(chartLeft, chartTop, chartWidth, chartHeight),
      );
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    // Draw data point dots (every 5th point + first + last)
    final dotPaint = Paint()..color = color;
    final dotBgPaint = Paint()..color = Colors.white;
    for (int i = 0; i < points.length; i++) {
      if (i == 0 || i == points.length - 1 || i % 5 == 0) {
        canvas.drawCircle(points[i], 4, dotBgPaint);
        canvas.drawCircle(points[i], 3, dotPaint);
      }
    }

    // Draw X-axis date labels (every ~6 days for 30-day data)
    final labelInterval = (data.length / 5).ceil();
    for (int i = 0; i < data.length; i += labelInterval) {
      final tp = TextPainter(
        text: TextSpan(
          text: _formatDate(data[i].date),
          style: TextStyle(color: textColor, fontSize: 10),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      final x = points[i].dx - tp.width / 2;
      tp.paint(canvas, Offset(x, chartBottom + 6));
    }
    // Always draw the last label
    if (data.length % labelInterval != 1) {
      final lastIdx = data.length - 1;
      final tp = TextPainter(
        text: TextSpan(
          text: _formatDate(data[lastIdx].date),
          style: TextStyle(color: textColor, fontSize: 10),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      final x = (points[lastIdx].dx - tp.width / 2)
          .clamp(chartLeft, chartRight - tp.width);
      tp.paint(canvas, Offset(x, chartBottom + 6));
    }
  }

  String _formatAxisValue(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(1);
  }

  @override
  bool shouldRepaint(covariant _DetailLinePainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.color != color;
  }
}
