import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/core/constants/api_constants.dart';
import 'package:news_app/core/constants/news_category.dart'; // <-- Cukup yang ini saja
import 'package:news_app/data/services/news_api_exception.dart';

import '../models/article.dart';

class NewsApiService {
  final http.Client _client;

  NewsApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Mengambil artikel berdasarkan salah satu dari 6 kategori pendidikan JEJAK.
  Future<List<Article>> fetchByCategory(
    NewsCategory category, {
    String? lang,
  }) async {
    return _get('/search', {
      'q': category.gnewsQuery,
      'lang': lang ?? ApiConstants.language,
      'sortby': 'publishedAt',
    }, categoryLabel: category.label);
  }

  /// Mencari artikel berdasarkan kata kunci bebas di halaman Explore.
  Future<List<Article>> searchArticles(
    String query, {
    String? lang,
    String categoryLabel = 'Explore',
  }) async {
    return _get('/search', {
      'q': query,
      if (lang != null) 'lang': lang,
      'sortby': 'relevance',
    }, categoryLabel: categoryLabel);
  }

  Future<List<Article>> _get(
    String path,
    Map<String, String> params, {
    required String categoryLabel,
  }) async {
    final apiKey = ApiConstants.apiKey;
    if (apiKey.isEmpty) {
      debugPrint('[JEJAK] GNEWS_API_KEY kosong. Isi API Key di file .env');
      throw NewsApiException.serviceUnavailable;
    }

    // GNews menggunakan parameter 'apikey' dan 'max' di dalam URL query
    final uri = Uri.parse('${ApiConstants.baseUrl}$path').replace(
      queryParameters: {
        ...params,
        'max': '${ApiConstants.maxArticles}',
        'apikey': apiKey,
      },
    );

    try {
      final response = await _client.get(uri).timeout(ApiConstants.timeout);

      if (response.statusCode != 200) {
        debugPrint('[JEJAK] HTTP ${response.statusCode}: ${response.body}');
        throw _fromStatusCode(response.statusCode);
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final articles = body['articles'] as List<dynamic>? ?? [];

      return articles
          .map(
            (json) => Article.fromJson(
              json as Map<String, dynamic>,
              category: categoryLabel,
            ),
          )
          .where((article) => article.isValid)
          .toList();
    } on NewsApiException {
      rethrow;
    } on SocketException {
      throw NewsApiException.offline;
    } on http.ClientException {
      throw NewsApiException.offline;
    } on TimeoutException {
      throw NewsApiException.slowConnection;
    } catch (error) {
      debugPrint('[JEJAK] Unexpected error: $error');
      throw NewsApiException.unknown;
    }
  }

  NewsApiException _fromStatusCode(int code) => switch (code) {
    401 || 403 => NewsApiException.serviceUnavailable,
    429 => NewsApiException.tooManyRequests,
    >= 500 => NewsApiException.serverBusy,
    _ => NewsApiException.unknown,
  };
}
