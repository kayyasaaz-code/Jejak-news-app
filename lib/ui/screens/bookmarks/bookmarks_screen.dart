import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/bookmark_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/theme_toggle_button.dart';
import 'widgets/bookmark_item.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar.large(
          title: Text('Bookmark'),
          actions: [ThemeToggleButton(), SizedBox(width: 8)],
        ),
        bookmarksAsync.when(
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => SliverFillRemaining(
            child: Center(child: Text('Gagal memuat bookmark: $error')),
          ),
          data: (bookmarks) {
            if (bookmarks.isEmpty) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(
                  icon: Icons.bookmark_border_rounded,
                  title: 'Belum ada artikel tersimpan',
                  message: 'Ketuk ikon bookmark pada artikel pendidikan\nuntuk membacanya kembali nanti.',
                ),
              );
            }

            return SliverList.separated(
              itemCount: bookmarks.length,
              separatorBuilder: (_, _) =>
                  const Divider(indent: 16, endIndent: 16),
              itemBuilder: (_, index) {
                return BookmarkItem(article: bookmarks[index]);
              },
            );
          },
        ),
      ],
    );
  }
}
