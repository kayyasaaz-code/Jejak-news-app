import 'package:news_app/core/constants/news_category.dart';

import '../models/article.dart';
import '../services/news_api_service.dart';

class NewsRepository {
  NewsRepository(this._apiService);

  final NewsApiService _apiService;

  // Cache ringan di memori untuk hasil pencarian (menghemat kuota 100 req/hari GNews)
  final Map<String, List<Article>> _searchCache = {};

  /// Mengambil artikel berdasarkan salah satu dari 6 kategori pendidikan JEJAK.
  Future<List<Article>> getByCategory(
    NewsCategory category, {
    bool forceRefresh = false,
  }) async {
    final articles = await _apiService.fetchByCategory(category);
    return _deduplicate(articles);
  }

  /// Mencari artikel berdasarkan kata kunci bebas di halaman Explore.
  Future<List<Article>> searchArticles(
    String query, {
    bool forceRefresh = false,
  }) async {
    final normalizedKey = query.trim().toLowerCase();
    if (normalizedKey.isEmpty) return [];

    if (!forceRefresh && _searchCache.containsKey(normalizedKey)) {
      return _searchCache[normalizedKey]!;
    }

    final articles = await _apiService.searchArticles(query.trim());
    final uniqueArticles = _deduplicate(articles);

    _searchCache[normalizedKey] = uniqueArticles;
    return uniqueArticles;
  }

  /// Menghapus artikel duplikat berdasarkan URL sambil mempertahankan urutan.
  List<Article> _deduplicate(List<Article> articles) {
    final seenUrls = <String>{};
    return articles.where((article) => seenUrls.add(article.url)).toList();
  }

  void clearCache() => _searchCache.clear();
}
