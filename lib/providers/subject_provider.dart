import 'package:flutter/foundation.dart';

import '../models/subject.dart';

class SubjectProvider with ChangeNotifier {
  final List<Subject> _subjects = [];

  List<Subject> get subjects => List.unmodifiable(_subjects);

  int get totalSubjects => _subjects.length;

  double get averageMark {
    if (_subjects.isEmpty) {
      return 0;
    }

    final total = _subjects
        .map((subject) => subject.mark)
        .fold<int>(0, (sum, mark) => sum + mark);

    return total / _subjects.length;
  }

  String get overallGrade {
    if (_subjects.isEmpty) {
      return 'N/A';
    }

    final average = averageMark;

    if (average >= 80) {
      return 'A';
    }
    if (average >= 65) {
      return 'B';
    }
    if (average >= 50) {
      return 'C';
    }
    return 'F';
  }

  int get passedSubjects =>
      _subjects.where((subject) => subject.grade != 'F').length;

  int get failedSubjects =>
      _subjects.where((subject) => subject.grade == 'F').length;

  void addSubject({required String name, required int mark}) {
    _subjects.add(Subject(name: name, mark: mark));
    notifyListeners();
  }

  void removeSubject(Subject subject) {
    _subjects.remove(subject);
    notifyListeners();
  }

  void clearAll() {
    _subjects.clear();
    notifyListeners();
  }
}
