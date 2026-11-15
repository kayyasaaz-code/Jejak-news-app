import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/news_category.dart';

/// Menyimpan & mengelola pilihan "My Interests" pengguna di SharedPreferences.
class MyInterestsNotifier extends Notifier<List<NewsCategory>> {
  static const _storageKey = 'jejak_my_interests';

  @override
  List<NewsCategory> build() {
    _loadFromPrefs();
    return [NewsCategory.scholarships, NewsCategory.competitions];
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNames = prefs.getStringList(_storageKey);
    if (savedNames != null && savedNames.isNotEmpty) {
      final loaded = savedNames
          .map(
            (name) =>
                NewsCategory.values.where((c) => c.name == name).firstOrNull,
          )
          .whereType<NewsCategory>()
          .toList();
      if (loaded.isNotEmpty) {
        state = loaded;
      }
    }
  }

  Future<void> toggleInterest(NewsCategory category) async {
    final current = [...state];
    if (current.contains(category)) {
      // Pertahankan minimal 1 minat agar bagian "For You" selalu punya konten
      if (current.length > 1) {
        current.remove(category);
      }
    } else {
      current.add(category);
    }
    state = current;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, current.map((c) => c.name).toList());
  }
}

final myInterestsProvider =
    NotifierProvider<MyInterestsNotifier, List<NewsCategory>>(
      MyInterestsNotifier.new,
    );

/// Menyimpan & mengelola riwayat pencarian (Search History) di SharedPreferences.
class SearchHistoryNotifier extends Notifier<List<String>> {
  static const _storageKey = 'jejak_search_history';

  @override
  List<String> build() {
    _loadFromPrefs();
    return [];
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_storageKey);
    if (saved != null) {
      state = saved;
    }
  }

  Future<void> addKeyword(String keyword) async {
    final clean = keyword.trim();
    if (clean.isEmpty) return;

    final updated = [
      clean,
      ...state.where((item) => item.toLowerCase() != clean.toLowerCase()),
    ].take(6).toList();

    state = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, updated);
  }

  Future<void> removeKeyword(String keyword) async {
    final updated = state.where((item) => item != keyword).toList();
    state = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, updated);
  }

  Future<void> clearAll() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}

final searchHistoryProvider =
    NotifierProvider<SearchHistoryNotifier, List<String>>(
      SearchHistoryNotifier.new,
    );
