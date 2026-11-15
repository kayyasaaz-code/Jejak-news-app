import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../providers/headlines_provider.dart';
import '../../../widgets/article_tile.dart';
import 'featured_article_card.dart';

class HeadlinesSection extends ConsumerWidget {
  const HeadlinesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(selectedCategoryProvider);
    final articlesAsync = ref.watch(headlinesProvider(category));

    return articlesAsync.when(
      loading: () => const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (err, _) => SliverFillRemaining(
        hasScrollBody: false,
        child: _InlineStatusView(
          message: err.toString().replaceFirst('Exception: ', ''),
          onRetry: () => ref.invalidate(headlinesProvider(category)),
        ),
      ),
      data: (articles) {
        if (articles.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: _InlineStatusView(
              message: 'Belum ada info untuk kategori ini.',
              onRetry: () => ref.invalidate(headlinesProvider(category)),
            ),
          );
        }

        final featured = articles.first;
        final rest = articles.skip(1).toList();

        return SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(child: FeaturedArticleCard(article: featured)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              sliver: SliverList.builder(
                itemCount: rest.length,
                itemBuilder: (context, index) =>
                    ArticleTile(article: rest[index]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InlineStatusView extends StatelessWidget {
  const _InlineStatusView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.mutedInk,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Muat Ulang'),
            ),
          ],
        ),
      ),
    );
  }
}
