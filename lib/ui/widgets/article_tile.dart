import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/article.dart';
import '../../providers/reading_mode_provider.dart';
import 'article_image.dart';
import 'bookmark_button.dart';

class ArticleTile extends ConsumerWidget {
  const ArticleTile({super.key, required this.article});

  final Article article;

  String _estimateReadTime() {
    final text =
        '${article.title} ${article.description ?? ''} ${article.content ?? ''}';
    final words = text
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .length;
    final minutes = (words / 180).ceil().clamp(2, 8);
    return '$minutes mnt baca';
  }

  (Color bg, Color fg) _categoryPalette(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('competition') || lower.contains('exchange')) {
      return (
        AppColors.glazeBlue.withValues(alpha: 0.65),
        AppColors.glazeBlueInk,
      );
    }
    if (lower.contains('learning') || lower.contains('test')) {
      return (
        AppColors.sageGreen.withValues(alpha: 0.75),
        AppColors.sageGreenInk,
      );
    }
    return (
      AppColors.warmButter.withValues(alpha: 0.7),
      AppColors.warmButterInk,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final isDark = brightness == Brightness.dark;
    final readingMode = ref.watch(readingModeProvider);
    final textScaler = TextScaler.linear(readingMode.textScale);
    final description = article.description?.trim();
    final (catBg, catFg) = _categoryPalette(article.category);

    final cardColor = readingMode.paperTone.cardColor(brightness);
    final borderColor = readingMode.paperTone.borderColor(brightness);
    final secondaryTextColor = isDark ? Colors.white70 : AppColors.mutedInk;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: borderColor, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => AppRouter.openArticle(context, article),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            DateFormatter.relative(article.publishedAt),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: secondaryTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 11.5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '·',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            _estimateReadTime(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: secondaryTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 11.5,
                            ),
                          ),
                          if (readingMode.compactMode) ...[
                            const Spacer(),
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: BookmarkButton(article: article),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        article.title,
                        textScaler: textScaler,
                        maxLines: readingMode.compactMode ? 3 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.26,
                          letterSpacing: -0.2,
                          color: isDark ? Colors.white : AppColors.ink,
                        ),
                      ),
                      if (description != null && description.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          description,
                          textScaler: textScaler,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: secondaryTextColor,
                            fontSize: 12.5,
                            height: 1.38,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _TagPill(
                            label: article.category,
                            backgroundColor: isDark
                                ? catBg.withValues(alpha: 0.25)
                                : catBg,
                            textColor: isDark ? Colors.white : catFg,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: _TagPill(
                              label: article.sourceName,
                              backgroundColor: isDark
                                  ? Colors.white10
                                  : AppColors.sageGreen.withValues(alpha: 0.55),
                              textColor: isDark
                                  ? Colors.white70
                                  : AppColors.sageGreenInk,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!readingMode.compactMode) ...[
                  const SizedBox(width: 14),
                  SizedBox(
                    width: 106,
                    height: 138,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: ArticleImage(url: article.imageUrl, radius: 0),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 34,
                            height: 34,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.ink.withValues(alpha: 0.85)
                                  : AppColors.cardWhite.withValues(alpha: 0.94),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: borderColor, width: 1),
                            ),
                            child: IconButtonTheme(
                              data: IconButtonThemeData(
                                style: IconButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  fixedSize: const Size(34, 34),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  iconSize: 18,
                                ),
                              ),
                              child: BookmarkButton(article: article),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
