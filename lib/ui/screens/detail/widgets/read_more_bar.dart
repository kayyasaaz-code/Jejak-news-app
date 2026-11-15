import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/core/theme/app_theme.dart';
import 'package:news_app/providers/navigation_provider.dart';
import 'package:news_app/providers/rencanaku_provider.dart';

import '../../../../core/utils/url_helper.dart';
import '../../../../data/models/article.dart';

class ReadMoreBar extends ConsumerWidget {
  const ReadMoreBar({super.key, required this.article});

  final Article article;

  void _showAddPlanDialog(BuildContext context, WidgetRef ref) {
    final notesController = TextEditingController();
    bool includeRoadmap = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                4,
                20,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Simpan ke Rencanaku',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Jadikan artikel ini sebagai rencana persiapan pribadimu.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: notesController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Catatan awal (opsional)',
                      hintText:
                          'Misal: Cek syarat IELTS & mulai siapkan esai...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: AppTheme.freshGreen,
                    title: const Text('Gunakan Suggested Roadmap'),
                    subtitle: Text(
                      'Tambahkan checklist persiapan otomatis untuk kategori ${article.category}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    value: includeRoadmap,
                    onChanged: (val) =>
                        setModalState(() => includeRoadmap = val),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.freshGreen,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      icon: const Icon(Icons.flag_rounded),
                      label: const Text('Buat Rencana Sekarang'),
                      onPressed: () async {
                        await ref
                            .read(rencanakuProvider.notifier)
                            .addArticleToPlan(
                              article,
                              includeSuggestedRoadmap: includeRoadmap,
                              initialNotes: notesController.text.trim(),
                            );
                        if (sheetContext.mounted) {
                          Navigator.of(sheetContext).pop();
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Berhasil ditambahkan ke Rencanaku!',
                              ),
                              action: SnackBarAction(
                                label: 'Lihat',
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ref
                                      .read(navigationProvider.notifier)
                                      .goToRencanaku();
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(rencanakuProvider);
    final alreadyAdded = plans.any((p) => p.article.url == article.url);

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Row(
        children: [
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 50),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: const Text('Sumber'),
            onPressed: () => UrlHelper.open(context, article.url),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: alreadyAdded
                    ? AppTheme.softGreen
                    : AppTheme.freshGreen,
                foregroundColor: alreadyAdded
                    ? AppTheme.freshGreen
                    : Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              icon: Icon(
                alreadyAdded ? Icons.check_circle_rounded : Icons.flag_rounded,
              ),
              label: Text(
                alreadyAdded ? 'Tersimpan di Rencanaku' : 'Add to Rencanaku',
              ),
              onPressed: alreadyAdded
                  ? () {
                      Navigator.of(context).pop();
                      ref.read(navigationProvider.notifier).goToRencanaku();
                    }
                  : () => _showAddPlanDialog(context, ref),
            ),
          ),
        ],
      ),
    );
  }
}
