import 'package:flutter/material.dart';

import '../models/subject.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    required this.subject,
    required this.onDismissed,
  });

  final Subject subject;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final gradeColor = _gradeColor(subject.grade, colorScheme);
    final progress = subject.mark / 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: gradeColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  subject.grade,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: gradeColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      minHeight: 7,
                      value: progress,
                      color: gradeColor,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mark: ${subject.mark} | Grade: ${subject.grade}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.drag_indicator, color: colorScheme.outline),
          ],
        ),
      ),
    );
  }

  Color _gradeColor(String grade, ColorScheme colorScheme) {
    switch (grade) {
      case 'A':
        return const Color(0xFF059669);
      case 'B':
        return const Color(0xFF2563EB);
      case 'C':
        return const Color(0xFFD97706);
      default:
        return colorScheme.error;
    }
  }
}
