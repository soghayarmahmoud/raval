// ✅ الكود الصحيح لـ DynamicTextProvider.dart

import 'package:flutter/material.dart';
import '../services/dynamic_content_service.dart';

class DynamicTextProvider extends ChangeNotifier {
  final DynamicContentService _contentService = DynamicContentService();
  Map<String, String> _content = {};
  String _currentLocale = 'ar';

  // 1. الـ Constructor الآن أصبح فارغًا ولا يسبب أي تغييرات
  DynamicTextProvider();

  String get currentLocale => _currentLocale;

  void setLocale(String locale) {
    _currentLocale = locale;
    loadContent(); // يستدعي الدالة العامة الجديدة
    // لا نحتاج notifyListeners هنا لأن loadContent ستقوم بذلك
  }

  // 2. تم تغيير اسم الدالة لتكون عامة (public)
  Future<void> loadContent() async {
    _content = await _contentService.getAllContent(_currentLocale);
    notifyListeners();
  }

  String getText(String key) {
    return _content[key] ?? key;
  }

  Stream<String> getTextStream(String key) {
    return _contentService.contentStream(key, _currentLocale);
  }
}