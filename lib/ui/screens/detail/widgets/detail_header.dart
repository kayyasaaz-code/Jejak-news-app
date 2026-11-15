import 'package:flutter/material.dart';
import 'package:news_app/core/theme/app_theme.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../data/models/article.dart';
import '../../../widgets/source_label.dart';

class DetailHeader extends StatelessWidget {
  const DetailHeader({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final source = article.sourceName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.softGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            article.category,
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppTheme.freshGreen,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(article.title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 18),
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppTheme.softGreen,
              child: Text(
                source.isNotEmpty ? source.characters.first.toUpperCase() : 'J',
                style: const TextStyle(
                  color: AppTheme.freshGreen,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SourceLabel(name: source),
                  const SizedBox(height: 2),
                  Text(
                    DateFormatter.full(article.publishedAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
