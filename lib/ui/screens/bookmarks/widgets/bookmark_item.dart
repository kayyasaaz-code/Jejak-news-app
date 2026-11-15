import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/bookmark_provider.dart';

import '../../../../data/models/article.dart';
import '../../../widgets/article_tile.dart';

class BookmarkItem extends ConsumerWidget {
  const BookmarkItem({super.key, required this.article});

  final Article article;

  void _remove(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(bookmarksProvider.notifier);
    notifier.toggleBookmark(article);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Dihapus dari Bookmark'),
          action: SnackBarAction(
            label: 'Urungkan',
            onPressed: () {
              notifier.toggleBookmark(article);
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(article.url),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _remove(context, ref),
      background: Container(
        color: scheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Icon(
          Icons.delete_outline_rounded,
          color: scheme.onErrorContainer,
        ),
      ),
      child: ArticleTile(article: article),
    );
  }
}
