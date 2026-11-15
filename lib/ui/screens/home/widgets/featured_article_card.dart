import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../data/models/article.dart';
import '../../../../providers/reading_mode_provider.dart';
import '../../../widgets/article_image.dart';
import '../../../widgets/bookmark_button.dart';

class FeaturedArticleCard extends ConsumerWidget {
  const FeaturedArticleCard({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final isDark = brightness == Brightness.dark;
    final readingMode = ref.watch(readingModeProvider);
    final textScaler = TextScaler.linear(readingMode.textScale);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: readingMode.paperTone.cardColor(brightness),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: readingMode.paperTone.borderColor(brightness),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => AppRouter.openArticle(context, article),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!readingMode.compactMode) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ArticleImage(url: article.imageUrl, radius: 0),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warmButter.withValues(
                            alpha: isDark ? 0.85 : 0.65,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          article.category,
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          article.sourceName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isDark ? Colors.white70 : AppColors.mutedInk,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    textScaler: textScaler,
                    maxLines: readingMode.compactMode ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: isDark ? Colors.white : AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        DateFormatter.relative(article.publishedAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.white70 : AppColors.mutedInk,
                        ),
                      ),
                      const Spacer(),
                      BookmarkButton(article: article),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
