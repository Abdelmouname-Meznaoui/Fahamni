import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  LocaleService._();

  static const String _languageCodeKey = 'preferred_language_code';

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('ar'),
  ];

  static const Map<String, String> languageNameKeys = {
    'en': 'english',
    'fr': 'french',
    'ar': 'arabic',
  };

  static final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('en'));

  static Future<void> init() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String savedCode = preferences.getString(_languageCodeKey) ?? 'en';
    final String normalizedCode = supportedLocales.any((locale) => locale.languageCode == savedCode)
        ? savedCode
        : 'en';
    localeNotifier.value = Locale(normalizedCode);
  }

  static Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.any((supported) => supported.languageCode == locale.languageCode)) {
      return;
    }
    localeNotifier.value = locale;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(_languageCodeKey, locale.languageCode);
  }

  static Locale get currentLocale => localeNotifier.value;
}
