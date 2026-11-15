import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/core/theme/app_theme.dart';
import 'package:news_app/providers/navigation_provider.dart';
import 'package:news_app/providers/rencanaku_provider.dart';
import 'package:news_app/ui/widgets/article_image.dart';
import 'package:news_app/ui/widgets/empty_state.dart';

import 'plan_detail_screen.dart';

class RencanakuScreen extends ConsumerWidget {
  const RencanakuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(rencanakuProvider);
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rencanaku', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 2),
                Text(
                  'Ubah informasi pendidikan menjadi langkah nyata',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: plans.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const EmptyState(
                          icon: Icons.flag_outlined,
                          title: 'Belum ada rencana persiapan',
                          message: 'Buka artikel beasiswa atau kompetisi lalu tekan "Add to Rencanaku" untuk mulai menyusun langkahmu.',
                        ),
                        const SizedBox(height: 8),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.freshGreen,
                          ),
                          onPressed: () => ref
                              .read(navigationProvider.notifier)
                              .goToExplore(),
                          icon: const Icon(Icons.explore_rounded),
                          label: const Text('Explore Peluang'),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: plans.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      final percent = (plan.progress * 100).round();

                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    PlanDetailScreen(planId: plan.id),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 72,
                                      height: 72,
                                      child: ArticleImage(
                                        url: plan.article.imageUrl,
                                        radius: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppTheme.softGreen,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              plan.article.category,
                                              style: theme.textTheme.labelSmall
                                                  ?.copyWith(
                                                    color: AppTheme.freshGreen,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            plan.article.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.titleSmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${plan.completedCount} dari ${plan.checklist.length} tugas selesai',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    Text(
                                      '$percent%',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: AppTheme.freshGreen,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: plan.progress,
                                    minHeight: 6,
                                    backgroundColor: AppTheme.softGreen,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          AppTheme.freshGreen,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
