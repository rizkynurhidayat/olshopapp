// theme.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFFCF3F6); // Pink sangat muda
  static const Color primaryText = Color(0xFF333333);
  static const Color secondaryText = Color(0xFF888888);
  static const Color primaryPink = Color(0xFFD46B8B); // Warna tombol
  static const Color surfaceWhite = Colors.white;
}

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  fontFamily: 'Poppins', // Pastikan Anda menambahkan font ini di pubspec.yaml
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.primaryText),
  ),
);