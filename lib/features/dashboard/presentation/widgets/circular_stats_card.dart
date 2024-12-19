import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularStatsCard extends StatelessWidget {
  final String title;
  final int value;
  final int maxValue;
  final IconData icon;
  final Color color;

  const CircularStatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.maxValue,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon and Title
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: color,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Circle with Value
        SizedBox(
          width: 85,
          height: 85,
          child: CustomPaint(
            painter: CircularProgressPainter(
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              valueColor: color,
              value: value / maxValue,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$value / $maxValue',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final Color backgroundColor;
  final Color valueColor;
  final double value;
  final double strokeWidth;

  CircularProgressPainter({
    required this.backgroundColor,
    required this.valueColor,
    required this.value,
    this.strokeWidth = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Paint valuePaint = Paint()
      ..color = valueColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);

    // Draw background circle
    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      0,
      2 * math.pi * value,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.valueColor != valueColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
