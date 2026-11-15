import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:news_app/core/constants/news_category.dart';
import 'package:news_app/core/router/app_router.dart';
import 'package:news_app/core/theme/app_theme.dart';
import 'package:news_app/data/models/study_plan.dart';
import 'package:news_app/providers/rencanaku_provider.dart';

class PlanDetailScreen extends ConsumerStatefulWidget {
  const PlanDetailScreen({super.key, required this.planId});

  final String planId;

  @override
  ConsumerState<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends ConsumerState<PlanDetailScreen> {
  late final TextEditingController _notesController;
  final _newTaskController = TextEditingController();
  bool _notesInitialized = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _newTaskController.dispose();
    super.dispose();
  }

  Future<void> _saveNotes(StudyPlan plan) async {
    final updated = plan.copyWith(notes: _notesController.text.trim());
    await ref.read(rencanakuProvider.notifier).updatePlan(updated);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan pribadi tersimpan')),
      );
    }
  }

  Future<void> _addChecklistItem(StudyPlan plan, String title) async {
    final clean = title.trim();
    if (clean.isEmpty) return;

    final newItem = PlanChecklistItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: clean,
    );
    final updated = plan.copyWith(checklist: [...plan.checklist, newItem]);
    await ref.read(rencanakuProvider.notifier).updatePlan(updated);
    _newTaskController.clear();
  }

  Future<void> _toggleItem(StudyPlan plan, PlanChecklistItem item) async {
    final updatedList = [
      for (final c in plan.checklist)
        if (c.id == item.id) c.copyWith(isCompleted: !c.isCompleted) else c,
    ];
    await ref
        .read(rencanakuProvider.notifier)
        .updatePlan(plan.copyWith(checklist: updatedList));
  }

  Future<void> _pickTargetDate(StudyPlan plan, PlanChecklistItem item) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: item.targetDate ?? now.add(const Duration(days: 7)),
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 1095)),
    );
    if (picked == null) return;

    final updatedList = [
      for (final c in plan.checklist)
        if (c.id == item.id) c.copyWith(targetDate: picked) else c,
    ];
    await ref
        .read(rencanakuProvider.notifier)
        .updatePlan(plan.copyWith(checklist: updatedList));
  }

  Future<void> _deleteItem(StudyPlan plan, String itemId) async {
    final updatedList = plan.checklist.where((c) => c.id != itemId).toList();
    await ref
        .read(rencanakuProvider.notifier)
        .updatePlan(plan.copyWith(checklist: updatedList));
  }

  Future<void> _applySuggestedRoadmap(StudyPlan plan) async {
    final matchedCategory = NewsCategory.values.firstWhere(
      (c) => c.label.toLowerCase() == plan.article.category.toLowerCase(),
      orElse: () => NewsCategory.scholarships,
    );

    final now = DateTime.now();
    final suggestedItems = matchedCategory.defaultRoadmap.asMap().entries.map((
      entry,
    ) {
      return PlanChecklistItem(
        id: '${now.millisecondsSinceEpoch}_${entry.key}',
        title: entry.value,
      );
    }).toList();

    final updated = plan.copyWith(
      checklist: [...plan.checklist, ...suggestedItems],
    );
    await ref.read(rencanakuProvider.notifier).updatePlan(updated);
  }

  @override
  Widget build(BuildContext context) {
    final plans = ref.watch(rencanakuProvider);
    final plan = plans.where((p) => p.id == widget.planId).firstOrNull;

    if (plan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Rencana')),
        body: const Center(child: Text('Rencana tidak ditemukan')),
      );
    }

    if (!_notesInitialized) {
      _notesController.text = plan.notes;
      _notesInitialized = true;
    }

    final theme = Theme.of(context);
    final percent = (plan.progress * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Rencana'),
        actions: [
          IconButton(
            tooltip: 'Lihat artikel referensi',
            icon: const Icon(Icons.article_outlined),
            onPressed: () => AppRouter.openArticle(context, plan.article),
          ),
          IconButton(
            tooltip: 'Hapus rencana',
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () async {
              await ref.read(rencanakuProvider.notifier).removePlan(plan.id);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // 1. REFERENSI ARTIKEL & PROGRESS
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.softGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      plan.article.category,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.freshGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(plan.article.title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress Persiapan',
                        style: theme.textTheme.labelMedium,
                      ),
                      Text(
                        '${plan.completedCount}/${plan.checklist.length} selesai ($percent%)',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.freshGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: plan.progress,
                      minHeight: 8,
                      backgroundColor: AppTheme.softGreen,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.freshGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 2. PERSONAL NOTES
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Personal Notes', style: theme.textTheme.titleMedium),
              TextButton.icon(
                onPressed: () => _saveNotes(plan),
                icon: const Icon(Icons.check_rounded, size: 18),
                label: const Text('Simpan'),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _notesController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Tulis alasan tertarik, syarat penting, atau pertanyaan yang perlu dicari...',
              filled: true,
              fillColor: theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 3. TIMELINE & CHECKLIST + SUGGESTED ROADMAP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Timeline & Checklist', style: theme.textTheme.titleMedium),
              TextButton.icon(
                onPressed: () => _applySuggestedRoadmap(plan),
                icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: const Text('+ Roadmap'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newTaskController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (val) => _addChecklistItem(plan, val),
                  decoration: InputDecoration(
                    hintText: 'Tambah langkah persiapan baru...',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.freshGreen,
                ),
                icon: const Icon(Icons.add_rounded),
                onPressed: () =>
                    _addChecklistItem(plan, _newTaskController.text),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (plan.checklist.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Belum ada langkah persiapan. Gunakan template Suggested Roadmap atau tambah tugas manual.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonalIcon(
                      onPressed: () => _applySuggestedRoadmap(plan),
                      icon: const Icon(Icons.auto_awesome_rounded),
                      label: const Text('Gunakan Suggested Roadmap'),
                    ),
                  ],
                ),
              ),
            )
          else
            ...plan.checklist.map((item) {
              final dateText = item.targetDate != null
                  ? DateFormat('d MMM yyyy').format(item.targetDate!)
                  : 'Atur target';

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  leading: Checkbox(
                    activeColor: AppTheme.freshGreen,
                    value: item.isCompleted,
                    onChanged: (_) => _toggleItem(plan, item),
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      decoration: item.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      color: item.isCompleted
                          ? theme.colorScheme.onSurfaceVariant
                          : null,
                    ),
                  ),
                  subtitle: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => _pickTargetDate(plan, item),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 13,
                              color: item.targetDate != null
                                  ? AppTheme.freshGreen
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dateText,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: item.targetDate != null
                                    ? AppTheme.freshGreen
                                    : theme.colorScheme.onSurfaceVariant,
                                fontWeight: item.targetDate != null
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () => _deleteItem(plan, item.id),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
