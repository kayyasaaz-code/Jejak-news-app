class Article {
  const Article({
    required this.title,
    required this.sourceName,
    required this.url,
    required this.publishedAt,
    this.sourceUrl,
    this.description,
    this.imageUrl,
    this.content,
    this.category = 'Education',
  });

  final String title;
  final String sourceName;
  final String? sourceUrl;
  final String url;
  final DateTime? publishedAt;
  final String? description;
  final String? imageUrl;
  final String? content;
  final String category;

  // Membersihkan potongan karakter di akhir cuplikan konten GNews (misal: "... [1234 chars]")
  String get cleanContent =>
      (content ?? '').replaceAll(RegExp(r'\s*\[\d+\s*chars\]$'), '').trim();

  bool get isValid =>
      title.isNotEmpty && title != '[Removed]' && url.isNotEmpty;

  @override
  bool operator ==(Object other) => other is Article && other.url == url;

  @override
  int get hashCode => url.hashCode;

  Article copyWith({String? category}) {
    return Article(
      title: title,
      sourceName: sourceName,
      sourceUrl: sourceUrl,
      url: url,
      publishedAt: publishedAt,
      description: description,
      imageUrl: imageUrl,
      content: content,
      category: category ?? this.category,
    );
  }

  factory Article.fromJson(Map<String, dynamic> json, {String? category}) {
    final source = json['source'] as Map<String, dynamic>?;
    return Article(
      title: json['title'] as String? ?? '',
      url: json['url'] as String? ?? '',
      sourceName: source?['name'] as String? ?? 'Tanpa Sumber',
      sourceUrl: source?['url'] as String?,
      publishedAt: DateTime.tryParse(json['publishedAt'] as String? ?? ''),
      description: json['description'] as String?,
      // GNews menggunakan key 'image' (bukan 'urlToImage')
      imageUrl: json['image'] as String?,
      content: json['content'] as String?,
      category: category ?? (json['category'] as String? ?? 'Education'),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'url': url,
    'source': {'name': sourceName, if (sourceUrl != null) 'url': sourceUrl},
    'description': description,
    'content': content,
    'image': imageUrl,
    'publishedAt': publishedAt?.toIso8601String(),
    'category': category,
  };

  static final dummy = Article(
    title: 'Beasiswa MEXT Jepang 2027 Resmi Dibuka untuk Pelajar',
    sourceName: 'JEJAK Education',
    url: 'https://example.com',
    publishedAt: DateTime.now(),
    description:
        'Informasi lengkap mengenai pendaftaran beasiswa penuh ke Jepang.',
    imageUrl: 'https://picsum.photos/400/200',
    content: 'Persiapkan dokumen akademik dan sertifikat bahasa sejak dini.',
    category: 'Scholarships',
  );
}
