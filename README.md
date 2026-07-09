# Student Grade Tracker

A Flutter application for tracking student subject marks, calculating grades, and viewing a quick performance summary.

## Features

- Add subjects with marks from 0 to 100.
- View all saved subjects in a clean list.
- Swipe a subject to remove it.
- See total subjects, average mark, passed subjects, and failed subjects.
- View marks in a bar chart and pass/fail status in a pie chart.
- Toggle between light and dark themes.
- Navigate with bottom tabs for Add, Subjects, and Summary.

## Grade Rules

| Mark Range | Grade |
| --- | --- |
| 80-100 | A |
| 65-79 | B |
| 50-64 | C |
| 0-49 | F |

Subjects with grade `F` are counted as failed. All other grades are counted as passed.

## Tech Stack

- Flutter
- Dart
- Provider for state management
- Material Design

## Project Structure

```text
lib/
  app.dart
  main.dart
  models/
    subject.dart
  providers/
    navigation_provider.dart
    subject_provider.dart
    theme_provider.dart
  screens/
    add_subject_screen.dart
    home_screen.dart
    subject_list_screen.dart
    summary_screen.dart
  theme/
    app_theme.dart
  widgets/
    custom_textfield.dart
    page_frame.dart
    subject_card.dart
```

## Getting Started

### Prerequisites

Install Flutter and make sure it is available from your terminal:

```bash
flutter --version
```

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

To run on web:

```bash
flutter run -d chrome
```

## Testing

Run the Flutter test suite with:

```bash
flutter test
```

## Notes

The current app stores subjects in memory through `SubjectProvider`. Data will reset when the app restarts.
