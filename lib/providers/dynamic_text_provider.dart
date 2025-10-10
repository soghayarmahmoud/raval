import 'package:flutter/material.dart';
import '../services/dynamic_content_service.dart';

class DynamicTextProvider extends ChangeNotifier {
  final DynamicContentService _contentService = DynamicContentService();
  Map<String, String> _content = {};
  String _currentLocale = 'ar';

  DynamicTextProvider() {
    _loadContent();
  }

  String get currentLocale => _currentLocale;

  void setLocale(String locale) {
    _currentLocale = locale;
    _loadContent();
    notifyListeners();
  }

  Future<void> _loadContent() async {
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
