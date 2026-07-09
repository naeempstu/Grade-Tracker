import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4A6FA4),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF7F9FC),
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4A6FA4),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
  );
}
