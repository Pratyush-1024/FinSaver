import 'package:budget_tracker/models/translations.dart';
import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  void setLocale(Locale locale) {
    _currentLocale = locale;
    notifyListeners();
  }

  String translate(String key) {
    return translations[_currentLocale.languageCode]?[key] ?? key;
  }
}
