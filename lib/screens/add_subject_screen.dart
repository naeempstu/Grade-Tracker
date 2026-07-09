import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/subject_provider.dart';
import '../widgets/custom_textfield.dart';

class AddSubjectScreen extends StatefulWidget {
  const AddSubjectScreen({super.key});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _markController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _markController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<SubjectProvider>();
    provider.addSubject(
      name: _nameController.text.trim(),
      mark: int.parse(_markController.text.trim()),
    );

    _nameController.clear();
    _markController.clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Subject added successfully')));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Subject',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Track your grades with a clear overview.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      labelText: 'Subject Name',
                      icon: Icons.book_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a subject name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _markController,
                      labelText: 'Mark',
                      keyboardType: TextInputType.number,
                      icon: Icons.percent_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a mark';
                        }
                        final mark = int.tryParse(value);
                        if (mark == null) {
                          return 'Enter a valid number';
                        }
                        if (mark < 0 || mark > 100) {
                          return 'Mark must be between 0 and 100';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Save Subject'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
