import 'package:flutter/material.dart';

class AppColors {
  static const green = Color(0xFF17A772);
  static const greenDark = Color(0xFF118B62);
  static const bg = Color(0xFFF5F6F8);
  static const text = Color(0xFF18202A);
  static const muted = Color(0xFF8C97A8);
  static const yellow = Color(0xFFF0A529);
  static const softYellow = Color(0xFFFFF5DE);
  static const lightGreen = Color(0xFFE9FAF1);
  static const card = Colors.white;
  static const border = Color(0xFFECF0F4);
  static const blueSoft = Color(0xFFF0F5FF);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.green,
          primary: AppColors.green,
          surface: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.text),
        ),
      );
}
