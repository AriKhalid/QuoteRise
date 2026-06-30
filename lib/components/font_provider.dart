import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppFont { system, lato, playfair, nunito, raleway }

extension AppFontExtension on AppFont {
  String get displayName {
    switch (this) {
      case AppFont.system:   return 'System Default';
      case AppFont.lato:     return 'Lato';
      case AppFont.playfair: return 'Playfair Display';
      case AppFont.nunito:   return 'Nunito';
      case AppFont.raleway:  return 'Raleway';
    }
  }

  String? get fontFamily {
    switch (this) {
      case AppFont.system:   return null;
      case AppFont.lato:     return 'Lato';
      case AppFont.playfair: return 'PlayfairDisplay';
      case AppFont.nunito:   return 'Nunito';
      case AppFont.raleway:  return 'Raleway';
    }
  }

  String get previewText => 'The only way to do great work is to love what you do.';
}

class FontProvider extends ChangeNotifier {
  static const _key = 'selected_font';

  AppFont _font = AppFont.system;
  AppFont get font => _font;

  FontProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    if (saved != null) {
      _font = AppFont.values.firstWhere(
        (f) => f.name == saved,
        orElse: () => AppFont.system,
      );
      notifyListeners();
    }
  }

  Future<void> setFont(AppFont font) async {
    _font = font;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, font.name);
  }
}
