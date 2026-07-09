import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/subject.dart';
import '../providers/subject_provider.dart';
import '../widgets/subject_card.dart';

class SubjectListScreen extends StatelessWidget {
  const SubjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjectProvider = context.watch<SubjectProvider>();
    final subjects = subjectProvider.subjects;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: subjects.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 56,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Subjects Added',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Use the Add Subject tab to begin tracking grades.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return Dismissible(
                  key: ValueKey<Subject>(subject),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  onDismissed: (_) {
                    subjectProvider.removeSubject(subject);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${subject.name} removed')),
                    );
                  },
                  child: SubjectCard(subject: subject, onDismissed: () {}),
                );
              },
            ),
    );
  }
}
