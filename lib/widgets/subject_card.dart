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

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          subject.name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Mark: ${subject.mark} • Grade: ${subject.grade}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            subject.grade,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}
