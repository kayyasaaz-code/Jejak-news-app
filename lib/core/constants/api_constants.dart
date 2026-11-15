import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://gnews.io/api/v4';

  // Pastikan di file .env kamu tertulis: GNEWS_API_KEY=api_key_kamu
  static String get apiKey => (dotenv.maybeGet('GNEWS_API_KEY') ?? '').trim();

  // Bahasa default artikel ('en' atau 'id')
  static const String language = 'en';

  // Batas maksimal artikel per request pada paket gratis GNews adalah 10
  static const int maxArticles = 10;

  static const Duration timeout = Duration(seconds: 15);
}
