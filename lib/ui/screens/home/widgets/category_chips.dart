import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/core/theme/app_theme.dart';
import 'package:news_app/providers/headlines_provider.dart';

import '../../../../core/constants/news_category.dart';

class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  IconData _categoryIcon(NewsCategory category) => switch (category) {
    NewsCategory.scholarships => Icons.school_outlined,
    NewsCategory.competitions => Icons.emoji_events_outlined,
    NewsCategory.studentExchange => Icons.flight_takeoff_rounded,
    NewsCategory.universityAdmission => Icons.account_balance_outlined,
    NewsCategory.testPreparation => Icons.translate_rounded,
    NewsCategory.learningPrograms => Icons.laptop_mac_rounded,
  };

  String _shortLabel(NewsCategory category) => switch (category) {
    NewsCategory.scholarships => 'Beasiswa',
    NewsCategory.competitions => 'Lomba',
    NewsCategory.studentExchange => 'Exchange',
    NewsCategory.universityAdmission => 'Kampus',
    NewsCategory.testPreparation => 'Tes',
    NewsCategory.learningPrograms => 'Belajar',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const categories = NewsCategory.values;
    final selected = ref.watch(selectedCategoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Pilih kategori',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.mutedInk,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 82,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selected;

                return GestureDetector(
                  onTap: () => ref
                      .read(selectedCategoryProvider.notifier)
                      .select(category),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.warmButter
                              : (isDark ? Colors.white10 : AppColors.cardWhite),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.warmButterInk.withValues(alpha: 0.3)
                                : (isDark
                                      ? Colors.white12
                                      : AppColors.hairline),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          _categoryIcon(category),
                          size: 22,
                          color: isSelected
                              ? AppColors.ink
                              : (isDark ? Colors.white70 : AppColors.mutedInk),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _shortLabel(category),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? (isDark ? Colors.white : AppColors.ink)
                              : AppColors.mutedInk,
                        ),
                      ),
                    ],
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
