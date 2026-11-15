import 'package:flutter/material.dart';

import '../../../data/models/article.dart';
import 'widgets/detail_app_bar.dart';
import 'widgets/detail_content.dart';
import 'widgets/detail_header.dart';
import 'widgets/read_more_bar.dart';

class ArticleDetailScreen extends StatefulWidget {
  const ArticleDetailScreen({super.key, required this.article});

  final Article article;

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  static const _scales = [1.0, 1.15, 1.3];
  static const _labels = ['100%', '115%', '130%'];
  int _scaleIndex = 0;

  void _cycleTextScale() {
    setState(() {
      _scaleIndex = (_scaleIndex + 1) % _scales.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DetailAppBar(
            article: widget.article,
            onToggleTextScale: _cycleTextScale,
            textScaleLabel: _labels[_scaleIndex],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            sliver: SliverList.list(
              children: [
                DetailHeader(article: widget.article),
                const SizedBox(height: 24),
                DetailContent(
                  article: widget.article,
                  textScale: _scales[_scaleIndex],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ReadMoreBar(article: widget.article),
    );
  }
}
