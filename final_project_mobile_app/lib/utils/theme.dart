// lib/utils/theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme() {
    final seed = const Color(0xFF6366F1);

    final colorScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF7F8FB),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: seed,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefixIconColor: Colors.grey.shade700,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: seed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          minimumSize: const Size.fromHeight(48),
        ),
      ),
      textTheme: TextTheme(
        headlineSmall: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        bodyMedium: const TextStyle(fontSize: 14),
        labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        labelMedium: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        labelSmall: const TextStyle(fontSize: 12),
      ),
      dividerColor: Colors.grey.shade300,
    );
  }
}
