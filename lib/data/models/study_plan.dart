import 'article.dart';

class PlanChecklistItem {
  const PlanChecklistItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.targetDate,
  });

  final String id;
  final String title;
  final bool isCompleted;
  final DateTime? targetDate;

  PlanChecklistItem copyWith({
    String? title,
    bool? isCompleted,
    DateTime? targetDate,
    bool clearDate = false,
  }) {
    return PlanChecklistItem(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      targetDate: clearDate ? null : (targetDate ?? this.targetDate),
    );
  }

  factory PlanChecklistItem.fromJson(Map<String, dynamic> json) {
    return PlanChecklistItem(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      targetDate: json['targetDate'] != null
          ? DateTime.tryParse(json['targetDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted,
    'targetDate': targetDate?.toIso8601String(),
  };
}

class StudyPlan {
  const StudyPlan({
    required this.id,
    required this.article,
    this.notes = '',
    this.checklist = const [],
    required this.createdAt,
  });

  final String id;
  final Article article;
  final String notes;
  final List<PlanChecklistItem> checklist;
  final DateTime createdAt;

  int get completedCount => checklist.where((c) => c.isCompleted).length;

  double get progress =>
      checklist.isEmpty ? 0.0 : completedCount / checklist.length;

  StudyPlan copyWith({String? notes, List<PlanChecklistItem>? checklist}) {
    return StudyPlan(
      id: id,
      article: article,
      notes: notes ?? this.notes,
      checklist: checklist ?? this.checklist,
      createdAt: createdAt,
    );
  }

  factory StudyPlan.fromJson(Map<String, dynamic> json) {
    final rawChecklist = json['checklist'] as List<dynamic>? ?? [];
    return StudyPlan(
      id: json['id'] as String,
      article: Article.fromJson(json['article'] as Map<String, dynamic>),
      notes: json['notes'] as String? ?? '',
      checklist: rawChecklist
          .map((e) => PlanChecklistItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'article': article.toJson(),
    'notes': notes,
    'checklist': checklist.map((e) => e.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
  };
}
