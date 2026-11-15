import 'package:flutter/material.dart';

import '../../../../data/models/article.dart';

class DetailContent extends StatelessWidget {
  const DetailContent({super.key, required this.article, this.textScale = 1.0});

  final Article article;
  final double textScale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final description = article.description ?? '';
    final content = article.cleanContent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description.isNotEmpty)
          Text(
            description,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              height: 1.55,
              fontSize:
                  (theme.textTheme.titleMedium?.fontSize ?? 16) * textScale,
            ),
          ),
        if (content.isNotEmpty && content != description) ...[
          const SizedBox(height: 16),
          Text(
            content,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 16) * textScale,
            ),
          ),
        ],
        const SizedBox(height: 24),
        Card.filled(
          color: scheme.surfaceContainerHigh,
          margin: EdgeInsets.zero,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            leading: Icon(Icons.info_outline_rounded, color: scheme.primary),
            title: Text(
              'Cuplikan artikel dari ${article.sourceName}. Pastikan selalu memverifikasi jadwal & persyaratan resmi di situs penyelenggara.',
              style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}
