import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/core/constants/news_category.dart';
import 'package:news_app/data/models/article.dart';
import 'package:news_app/providers/dependency_provider.dart';

class SelectedCategoryNotifier extends Notifier<NewsCategory> {
  @override
  NewsCategory build() => NewsCategory.scholarships;

  void select(NewsCategory category) => state = category;
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, NewsCategory>(
      SelectedCategoryNotifier.new,
    );

// Alias agar kode UI lama yang memakai huruf kapital di awal tetap berjalan tanpa error
final SelectedCategoryProvider = selectedCategoryProvider;

// Mengambil artikel per kategori pendidikan (otomatis di-cache oleh Riverpod .family)
final headlinesProvider = FutureProvider.family<List<Article>, NewsCategory>((
  ref,
  category,
) {
  return ref.watch(newsRepositoryProvider).getByCategory(category);
});
