// In lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme(); // تحميل الثيم المحفوظ عند بدء التشغيل
  }

  // دالة لتحميل الثيم من الذاكرة المحلية
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // نقرأ القيمة المحفوظة، وإذا لم نجدها، نستخدم الثيم الافتراضي للنظام
    final themeIndex = prefs.getInt(_themeKey) ?? ThemeMode.system.index;
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }

  // دالة لحفظ الثيم في الذاكرة المحلية
  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return; // لا تقم بأي تحديث إذا لم يتغير الثيم
    _themeMode = mode;
    _saveTheme(mode); // حفظ الاختيار الجديد
    notifyListeners(); // إعلام كل أجزاء التطبيق بالتغيير
  }
}