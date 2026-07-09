import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/subject_provider.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjectProvider = context.watch<SubjectProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance Summary',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                    label: 'Overall Grade',
                    value: subjectProvider.overallGrade,
                    icon: Icons.grade_outlined,
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
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
