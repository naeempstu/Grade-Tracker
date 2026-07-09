import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/subject.dart';
import '../providers/subject_provider.dart';
import '../widgets/page_frame.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjectProvider = context.watch<SubjectProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PageFrame(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        subjectProvider.overallGrade,
                        style: textTheme.headlineSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Performance Summary',
                          style: textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Average mark ${subjectProvider.averageMark.toStringAsFixed(1)} across ${subjectProvider.totalSubjects} subjects.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSecondaryContainer.withValues(
                              alpha: 0.78,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 560;
                return GridView.count(
                  crossAxisCount: isWide ? 2 : 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isWide ? 2.6 : 3.8,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _SummaryTile(
                      label: 'Total Subjects',
                      value: '${subjectProvider.totalSubjects}',
                      icon: Icons.library_books_outlined,
                    ),
                    _SummaryTile(
                      label: 'Average Mark',
                      value: subjectProvider.averageMark.toStringAsFixed(1),
                      icon: Icons.percent_outlined,
                    ),
                    _SummaryTile(
                      label: 'Passed Subjects',
                      value: '${subjectProvider.passedSubjects}',
                      icon: Icons.check_circle_outline,
                    ),
                    _SummaryTile(
                      label: 'Failed Subjects',
                      value: '${subjectProvider.failedSubjects}',
                      icon: Icons.cancel_outlined,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 640;
                final charts = [
                  _MarksChartCard(subjects: subjectProvider.subjects),
                  _PassFailPieCard(
                    passed: subjectProvider.passedSubjects,
                    failed: subjectProvider.failedSubjects,
                  ),
                ];

                if (!isWide) {
                  return Column(
                    children: [
                      charts.first,
                      const SizedBox(height: 12),
                      charts.last,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: charts.first),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: charts.last),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.insights_outlined,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your summary updates automatically as subjects are added or removed.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarksChartCard extends StatelessWidget {
  const _MarksChartCard({required this.subjects});

  final List<Subject> subjects;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.stacked_bar_chart, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Marks Graph',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              width: double.infinity,
              child: subjects.isEmpty
                  ? const _ChartEmptyState(text: 'Add subjects to see graph')
                  : CustomPaint(
                      painter: _MarksBarPainter(
                        marks: subjects.map((subject) => subject.mark).toList(),
                        labels: subjects
                            .map((subject) => subject.name)
                            .toList(),
                        colorScheme: colorScheme,
                        textStyle: textTheme.labelSmall,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PassFailPieCard extends StatelessWidget {
  const _PassFailPieCard({required this.passed, required this.failed});

  final int passed;
  final int failed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final total = passed + failed;
    final passColor = const Color(0xFF059669);
    final failColor = colorScheme.error;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart_outline, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Pass/Fail Pie',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              width: double.infinity,
              child: total == 0
                  ? const _ChartEmptyState(text: 'Add subjects to see chart')
                  : Column(
                      children: [
                        Expanded(
                          child: CustomPaint(
                            painter: _PassFailPiePainter(
                              passed: passed,
                              failed: failed,
                              passColor: passColor,
                              failColor: failColor,
                              trackColor: colorScheme.surfaceContainerHighest,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${((passed / total) * 100).round()}%',
                                    style: textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: passColor,
                                    ),
                                  ),
                                  Text(
                                    'Passed',
                                    style: textTheme.labelMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _LegendDot(
                              color: passColor,
                              label: 'Passed $passed',
                            ),
                            const SizedBox(width: 16),
                            _LegendDot(
                              color: failColor,
                              label: 'Failed $failed',
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartEmptyState extends StatelessWidget {
  const _ChartEmptyState({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

class _MarksBarPainter extends CustomPainter {
  const _MarksBarPainter({
    required this.marks,
    required this.labels,
    required this.colorScheme,
    required this.textStyle,
  });

  final List<int> marks;
  final List<String> labels;
  final ColorScheme colorScheme;
  final TextStyle? textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = colorScheme.outlineVariant
      ..strokeWidth = 1;
    final gridPaint = Paint()
      ..color = colorScheme.outlineVariant.withValues(alpha: 0.6)
      ..strokeWidth = 1;
    final labelStyle =
        textStyle?.copyWith(color: colorScheme.onSurfaceVariant) ??
        TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 11);

    const left = 34.0;
    const right = 8.0;
    const top = 12.0;
    const bottom = 38.0;
    final chartWidth = size.width - left - right;
    final chartHeight = size.height - top - bottom;
    final origin = Offset(left, top + chartHeight);

    for (final value in [0, 50, 100]) {
      final y = top + chartHeight - (value / 100) * chartHeight;
      canvas.drawLine(
        Offset(left, y),
        Offset(size.width - right, y),
        gridPaint,
      );
      _drawText(
        canvas,
        '$value',
        Offset(0, y - 7),
        labelStyle,
        maxWidth: 28,
        align: TextAlign.right,
      );
    }

    canvas.drawLine(Offset(left, top), origin, axisPaint);
    canvas.drawLine(origin, Offset(size.width - right, origin.dy), axisPaint);

    final visibleCount = math.min(marks.length, 8);
    final start = marks.length - visibleCount;
    final visibleMarks = marks.sublist(start);
    final visibleLabels = labels.sublist(start);
    final slotWidth = chartWidth / visibleCount;
    final barWidth = math.min(34.0, slotWidth * 0.56);

    for (var i = 0; i < visibleMarks.length; i++) {
      final mark = visibleMarks[i].clamp(0, 100);
      final x = left + (slotWidth * i) + (slotWidth - barWidth) / 2;
      final barHeight = (mark / 100) * chartHeight;
      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, origin.dy - barHeight, barWidth, barHeight),
        const Radius.circular(6),
      );
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _markColor(mark),
            colorScheme.primary.withValues(alpha: 0.62),
          ],
        ).createShader(barRect.outerRect);

      canvas.drawRRect(barRect, paint);
      _drawText(
        canvas,
        '$mark',
        Offset(x - 6, origin.dy - barHeight - 18),
        labelStyle.copyWith(fontWeight: FontWeight.w700),
        maxWidth: barWidth + 12,
        align: TextAlign.center,
      );
      _drawText(
        canvas,
        _shortLabel(visibleLabels[i]),
        Offset(left + (slotWidth * i), origin.dy + 10),
        labelStyle,
        maxWidth: slotWidth,
        align: TextAlign.center,
      );
    }
  }

  Color _markColor(int mark) {
    if (mark >= 80) {
      return const Color(0xFF059669);
    }
    if (mark >= 65) {
      return const Color(0xFF2563EB);
    }
    if (mark >= 50) {
      return const Color(0xFFD97706);
    }
    return colorScheme.error;
  }

  String _shortLabel(String label) {
    if (label.length <= 6) {
      return label;
    }
    return '${label.substring(0, 5)}.';
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    TextStyle style, {
    required double maxWidth,
    TextAlign align = TextAlign.left,
  }) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: align,
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '.',
    )..layout(maxWidth: maxWidth);
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _MarksBarPainter oldDelegate) {
    return oldDelegate.marks != marks ||
        oldDelegate.labels != labels ||
        oldDelegate.colorScheme != colorScheme;
  }
}

class _PassFailPiePainter extends CustomPainter {
  const _PassFailPiePainter({
    required this.passed,
    required this.failed,
    required this.passColor,
    required this.failColor,
    required this.trackColor,
  });

  final int passed;
  final int failed;
  final Color passColor;
  final Color failColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final total = passed + failed;
    final shortestSide = math.min(size.width, size.height);
    final strokeWidth = math.max(18.0, shortestSide * 0.12);
    final radius = (shortestSide - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    paint.color = trackColor;
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2, false, paint);

    if (total == 0) {
      return;
    }

    final passedSweep = (passed / total) * math.pi * 2;
    paint.color = passColor;
    canvas.drawArc(rect, -math.pi / 2, passedSweep, false, paint);

    if (failed > 0) {
      paint.color = failColor;
      canvas.drawArc(
        rect,
        -math.pi / 2 + passedSweep,
        (failed / total) * math.pi * 2,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PassFailPiePainter oldDelegate) {
    return oldDelegate.passed != passed ||
        oldDelegate.failed != failed ||
        oldDelegate.passColor != passColor ||
        oldDelegate.failColor != failColor ||
        oldDelegate.trackColor != trackColor;
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: colorScheme.onPrimaryContainer),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
