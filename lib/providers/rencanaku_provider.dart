import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/news_category.dart';
import '../data/models/article.dart';
import '../data/models/study_plan.dart';

class RencanakuNotifier extends Notifier<List<StudyPlan>> {
  static const _storageKey = 'jejak_study_plans';

  @override
  List<StudyPlan> build() {
    _loadPlans();
    return [];
  }

  Future<void> _loadPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_storageKey) ?? [];
    state = rawList
        .map(
          (str) => StudyPlan.fromJson(jsonDecode(str) as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = state.map((plan) => jsonEncode(plan.toJson())).toList();
    await prefs.setStringList(_storageKey, rawList);
  }

  bool isAdded(String articleUrl) =>
      state.any((plan) => plan.article.url == articleUrl);

  /// Menambahkan artikel ke Rencanaku beserta opsi Suggested Roadmap sesuai kategori.
  Future<StudyPlan> addArticleToPlan(
    Article article, {
    required bool includeSuggestedRoadmap,
    String initialNotes = '',
  }) async {
    final existing = state
        .where((p) => p.article.url == article.url)
        .firstOrNull;
    if (existing != null) return existing;

    // Cari kategori yang cocok untuk mengambil defaultRoadmap
    final matchedCategory = NewsCategory.values.firstWhere(
      (c) => c.label.toLowerCase() == article.category.toLowerCase(),
      orElse: () => NewsCategory.scholarships,
    );

    final now = DateTime.now();
    final checklist = includeSuggestedRoadmap
        ? matchedCategory.defaultRoadmap.asMap().entries.map((entry) {
            return PlanChecklistItem(
              id: '${now.millisecondsSinceEpoch}_${entry.key}',
              title: entry.value,
            );
          }).toList()
        : <PlanChecklistItem>[];

    final newPlan = StudyPlan(
      id: now.millisecondsSinceEpoch.toString(),
      article: article,
      notes: initialNotes,
      checklist: checklist,
      createdAt: now,
    );

    state = [newPlan, ...state];
    await _persist();
    return newPlan;
  }

  Future<void> updatePlan(StudyPlan updated) async {
    state = [
      for (final plan in state)
        if (plan.id == updated.id) updated else plan,
    ];
    await _persist();
  }

  Future<void> removePlan(String planId) async {
    state = state.where((p) => p.id != planId).toList();
    await _persist();
  }
}

final rencanakuProvider = NotifierProvider<RencanakuNotifier, List<StudyPlan>>(
  RencanakuNotifier.new,
);
