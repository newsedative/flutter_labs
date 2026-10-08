import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const violet = Color(0xFF6958D8);
  static const ink = Color(0xFF20243A);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF7F7FB),
    colorScheme: ColorScheme.fromSeed(
      seedColor: violet,
      primary: violet,
      surface: Colors.white,
    ),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: ink,
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
      ),
      titleLarge: TextStyle(
        color: ink,
        fontSize: 19,
        fontWeight: FontWeight.w700,
      ),
      bodyMedium: TextStyle(color: Color(0xFF85889A), fontSize: 14),
    ),
  );
}
