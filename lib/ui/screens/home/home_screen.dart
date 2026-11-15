import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/headlines_provider.dart';
import '../../../providers/reading_mode_provider.dart';
import 'widgets/category_chips.dart';
import 'widgets/headlines_section.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_hero_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    final provider = headlinesProvider(ref.read(selectedCategoryProvider));
    ref.invalidate(provider);
    try {
      await ref.read(provider.future);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final paperTone = ref.watch(readingModeProvider.select((s) => s.paperTone));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      color: paperTone.canvasColor(brightness),
      child: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        onRefresh: () => _refresh(ref),
        child: const CustomScrollView(
          slivers: [
            HomeAppBar(),
            SliverToBoxAdapter(child: HomeHeroSection()),
            SliverToBoxAdapter(child: CategoryChips()),
            HeadlinesSection(),
          ],
        ),
      ),
    );
  }
}
