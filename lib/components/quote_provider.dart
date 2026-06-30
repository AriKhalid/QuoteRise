import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quote {
  final String text;
  final String author;
  final String category;

  Quote({required this.text, required this.author, required this.category});

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        text: json['text'],
        author: json['author'],
        category: json['category'] ?? 'mindset',
      );
}

const List<String> allCategories = [
  'mindset', 'hustle', 'growth', 'resilience', 'wisdom', 'faith',
];

enum QuoteMode { daily, fixed }

class QuoteProvider extends ChangeNotifier {
  static const _categoriesKey = 'selected_categories';
  static const _modeKey = 'quote_mode';
  static const _fixedIndexKey = 'fixed_quote_index';

  List<Quote> _allQuotes = [];
  List<Quote> _filtered = [];
  int _currentIndex = 0;
  String _loadedLang = '';
  Set<String> _selectedCategories = Set.from(allCategories);
  QuoteMode _mode = QuoteMode.daily;
  int _fixedIndex = 0;
  bool _prefsLoaded = false;

  List<Quote> get quotes => _filtered;
  Quote? get current => _filtered.isEmpty ? null : _filtered[_currentIndex];
  int get currentIndex => _currentIndex;
  bool get isLoaded => _filtered.isNotEmpty;
  Set<String> get selectedCategories => _selectedCategories;
  QuoteMode get mode => _mode;
  int get fixedIndex => _fixedIndex;

  QuoteProvider() {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_categoriesKey);
    if (saved != null && saved.isNotEmpty) {
      _selectedCategories = Set.from(saved);
    }
    _mode = prefs.getString(_modeKey) == 'fixed'
        ? QuoteMode.fixed
        : QuoteMode.daily;
    _fixedIndex = prefs.getInt(_fixedIndexKey) ?? 0;
    _prefsLoaded = true;

    // Quotes waren bereits geladen bevor prefs fertig — Filter neu anwenden
    if (_allQuotes.isNotEmpty) _applyFilter();
  }

  Future<void> load(String langCode) async {
    if (_loadedLang == langCode && _allQuotes.isNotEmpty) return;
    try {
      final String raw =
          await rootBundle.loadString('assets/quotes/$langCode.json');
      final List<dynamic> data = json.decode(raw);
      _allQuotes = data.map((e) => Quote.fromJson(e)).toList();
      _loadedLang = langCode;
      // Nur filtern wenn prefs bereits geladen
      if (_prefsLoaded) _applyFilter();
    } catch (_) {
      if (langCode != 'en') await load('en');
    }
  }

  void _applyFilter() {
    _filtered = _allQuotes
        .where((q) => _selectedCategories.contains(q.category))
        .toList();
    if (_filtered.isEmpty) _filtered = List.from(_allQuotes);
    _setCurrentIndex();
    _updateWidget();
    notifyListeners();
  }

  Future<void> _updateWidget() async {
    if (_filtered.isEmpty) return;
    final q = _filtered[_currentIndex];
    await HomeWidget.setAppGroupId('group.com.arikhalid.quoteriseapp');
    await HomeWidget.saveWidgetData('quote_text', q.text);
    await HomeWidget.saveWidgetData('quote_author', q.author);
    await HomeWidget.updateWidget(
      iOSName: 'DayQuotesWidget',
      androidName: 'DayQuotesWidgetSquare',
    );
  }

  void _setCurrentIndex() {
    if (_filtered.isEmpty) return;
    if (_mode == QuoteMode.fixed) {
      _currentIndex = _fixedIndex.clamp(0, _filtered.length - 1);
    } else {
      final now = DateTime.now();
      final seed = now.year * 10000 + now.month * 100 + now.day;
      _currentIndex = Random(seed).nextInt(_filtered.length);
    }
  }

  void goTo(int index) {
    if (index < 0 || index >= _filtered.length) return;
    _currentIndex = index;
    _updateWidget();
    notifyListeners();
  }

  Future<void> setMode(QuoteMode mode) async {
    _mode = mode;
    _setCurrentIndex();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modeKey, mode.name);
  }

  Future<void> setFixedQuote(int index) async {
    _fixedIndex = index.clamp(0, _filtered.isEmpty ? 0 : _filtered.length - 1);
    _currentIndex = _fixedIndex;
    _mode = QuoteMode.fixed;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_fixedIndexKey, _fixedIndex);
    await prefs.setString(_modeKey, QuoteMode.fixed.name);
  }

  Future<void> toggleCategory(String category) async {
    if (_selectedCategories.contains(category)) {
      if (_selectedCategories.length == 1) return;
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_categoriesKey, _selectedCategories.toList());
    _applyFilter();
  }
}
