// In lib/providers/locale_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  static const String _langKey = 'language_code';
  Locale _locale = const Locale('ar'); 

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString(_langKey) ?? 'ar';
    _locale = Locale(langCode);
    notifyListeners();
  }

  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, locale.languageCode);
  }

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    _saveLocale(locale);
    notifyListeners();
  }
}