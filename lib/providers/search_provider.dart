import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/dependency_provider.dart';

import '../data/models/article.dart';

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void submit(String query) {
    state = query.trim();
  }

  void clear() {
    state = '';
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

final searchResultsProvider = FutureProvider.autoDispose<List<Article>>((
  ref,
) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];

  final repository = ref.watch(newsRepositoryProvider);
  return repository.searchArticles(query);
});
