import 'package:flutter/material.dart';

import '../../../../data/models/article.dart';
import '../../../widgets/article_image.dart';
import '../../../widgets/bookmark_button.dart';

class DetailAppBar extends StatelessWidget {
  const DetailAppBar({
    super.key,
    required this.article,
    required this.onToggleTextScale,
    required this.textScaleLabel,
  });

  final Article article;
  final VoidCallback onToggleTextScale;
  final String textScaleLabel;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: 280,
      leading: Padding(
        padding: const EdgeInsets.all(6),
        child: IconButton.filledTonal(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: FilledButton.tonalIcon(
            onPressed: onToggleTextScale,
            icon: const Icon(Icons.format_size_rounded, size: 18),
            label: Text(textScaleLabel),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ),
        const SizedBox(width: 6),
        BookmarkButton(article: article, tonal: true),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: ArticleImage(url: article.imageUrl, radius: 0),
      ),
    );
  }
}
