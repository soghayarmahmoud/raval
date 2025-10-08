import 'package:flutter/material.dart';

// --- 1. فئة الألوان المخصصة لتسهيل الوصول إليها ---
class AppColors {
  // الألوان الأساسية من الشعار
  static const Color primaryPink = Color(0xFFD71E61);
  static const Color accentYellow = Color(0xFFFDB813);
  static const Color accentPurple = Color(0xFF8D25A8);
  static const Color accentTeal = Color(0xFF00828F);
  
  // ألوان النصوص الرئيسية
  static const Color textDark = Color(0xFF4E4D4D);
  static const Color textLight = Color(0xFFF5F5F5);

  // ألوان مريحة للعين للخلفيات
  static const Color backgroundLight = Color(0xFFFAF9F6); // أبيض مائل للصفرة
  static const Color backgroundDark = Color(0xFF1C1C1E); // أسود غير كامل

  // ألوان للأسطح (مثل الكروت والحاويات)
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF2C2C2E);
}


// --- 2. تعريف الثيم الفاتح (Light Theme) ---
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primaryPink,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  
  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryPink,
    secondary: AppColors.accentYellow,
    surface: AppColors.surfaceLight,
    onPrimary: Colors.white, // لون النص فوق اللون الأساسي
    onSecondary: Colors.black,
    onSurface: AppColors.textDark,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.surfaceLight,
    elevation: 0.5,
    iconTheme: IconThemeData(color: AppColors.textDark),
    titleTextStyle: TextStyle(
      color: AppColors.textDark,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.textDark),
    bodyMedium: TextStyle(color: AppColors.textDark),
    titleLarge: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryPink,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
  ),
);


// --- 3. تعريف الثيم الداكن (Dark Theme) ---
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primaryPink,
  scaffoldBackgroundColor: AppColors.backgroundDark,

  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryPink,
    secondary: AppColors.accentYellow,
    surface: AppColors.surfaceDark,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: AppColors.textLight,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.surfaceDark,
    elevation: 0.5,
    iconTheme: IconThemeData(color: AppColors.textLight),
    titleTextStyle: TextStyle(
      color: AppColors.textLight,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
  
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.textLight),
    bodyMedium: TextStyle(color: AppColors.textLight),
    titleLarge: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryPink,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
  ),
);