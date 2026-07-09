import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_provider.dart';
import '../providers/theme_provider.dart';
import 'add_subject_screen.dart';
import 'subject_list_screen.dart';
import 'summary_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Widget> _screens = [
    AddSubjectScreen(),
    SubjectListScreen(),
    SummaryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<NavigationProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Grade Tracker'),
        actions: [
          IconButton(
            onPressed: themeProvider.toggleTheme,
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: navigationProvider.currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationProvider.currentIndex,
        onTap: navigationProvider.updateIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add Subject',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Summary',
          ),
        ],
      ),
    );
  }
}
