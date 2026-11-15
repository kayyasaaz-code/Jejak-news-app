import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/core/constants/news_category.dart';
import 'package:news_app/core/theme/app_theme.dart';
import 'package:news_app/providers/explore_preferences_provider.dart';
import 'package:news_app/providers/headlines_provider.dart';
import 'package:news_app/providers/search_provider.dart';
import 'package:news_app/ui/widgets/article_tile.dart';

class SearchSuggestions extends ConsumerWidget {
  const SearchSuggestions({super.key});

  void _triggerSearch(WidgetRef ref, String keyword) {
    ref.read(searchQueryProvider.notifier).submit(keyword);
    ref.read(searchHistoryProvider.notifier).addKeyword(keyword);
  }

  void _showManageInterestsSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final myInterests = ref.watch(myInterestsProvider);
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih Minatmu',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: NewsCategory.values.map((category) {
                      final isSelected = myInterests.contains(category);
                      return FilterChip(
                        label: Text(category.label),
                        selected: isSelected,
                        selectedColor: AppColors.warmButter,
                        checkmarkColor: AppColors.ink,
                        onSelected: (_) {
                          ref
                              .read(myInterestsProvider.notifier)
                              .toggleInterest(category);
                        },
                      );
                    }).toList(),
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
    final theme = Theme.of(context);
    final history = ref.watch(searchHistoryProvider);
    final myInterests = ref.watch(myInterestsProvider);
    final primaryInterest = myInterests.first;
    final forYouArticlesAsync = ref.watch(headlinesProvider(primaryInterest));

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        if (history.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Terakhir Dicari', style: theme.textTheme.titleSmall),
              TextButton(
                onPressed: () =>
                    ref.read(searchHistoryProvider.notifier).clearAll(),
                child: const Text('Hapus'),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: history.map((item) {
              return InputChip(
                label: Text(item),
                onPressed: () => _triggerSearch(ref, item),
                onDeleted: () => ref
                    .read(searchHistoryProvider.notifier)
                    .removeKeyword(item),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],

        Text('Jelajahi Topik', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _SoftBentoCard(
                    title: 'Beasiswa\nUnggulan',
                    subtitle: 'LPDP, MEXT, IISMA',
                    color: AppColors.glazeBlue,
                    height: 140,
                    icon: Icons.school_outlined,
                    onTap: () => _triggerSearch(ref, 'Scholarship'),
                  ),
                  const SizedBox(height: 12),
                  _SoftBentoCard(
                    title: 'Student\nExchange',
                    subtitle: 'Program global',
                    color: AppColors.warmButter,
                    height: 112,
                    icon: Icons.flight_takeoff_rounded,
                    onTap: () => _triggerSearch(ref, 'Student Exchange'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  _SoftBentoCard(
                    title: 'Kompetisi &\nOlimpiade',
                    subtitle: 'Hackathon & lomba',
                    color: AppColors.cardWhite,
                    height: 112,
                    icon: Icons.emoji_events_outlined,
                    onTap: () => _triggerSearch(ref, 'Competition'),
                  ),
                  const SizedBox(height: 12),
                  _SoftBentoCard(
                    title: 'IELTS &\nPersiapan Tes',
                    subtitle: 'Bootcamp & belajar',
                    color: AppColors.sageGreen,
                    height: 140,
                    icon: Icons.translate_rounded,
                    onTap: () => _triggerSearch(ref, 'IELTS'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Untuk Kamu · ${primaryInterest.label}',
              style: theme.textTheme.titleMedium,
            ),
            TextButton(
              onPressed: () => _showManageInterestsSheet(context, ref),
              child: const Text('Ubah Minat'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        forYouArticlesAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => const Text('Gagal memuat rekomendasi.'),
          data: (articles) {
            final preview = articles.take(4).toList();
            return Column(
              children: preview
                  .map((article) => ArticleTile(article: article))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _SoftBentoCard extends StatelessWidget {
  const _SoftBentoCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.height,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Color color;
  final double height;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: height,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.hairline, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: AppColors.ink, size: 21),
                  Icon(
                    Icons.north_east_rounded,
                    color: AppColors.ink.withValues(alpha: 0.6),
                    size: 17,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.18,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.mutedInk,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
