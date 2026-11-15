import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../providers/reading_mode_provider.dart';
import '../../../widgets/theme_toggle_button.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key});

  void _openReadingModeSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ReadingModeBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final isDark = brightness == Brightness.dark;
    final readingMode = ref.watch(readingModeProvider);

    return SliverAppBar(
      floating: true,
      snap: true,
      toolbarHeight: 72,
      titleSpacing: 20,
      backgroundColor: readingMode.paperTone.canvasColor(brightness),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormatter.today(),
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : AppColors.mutedInk,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Jejak',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  height: 1.1,
                  color: isDark ? Colors.white : AppColors.ink,
                ),
              ),
              Text(
                '.',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  color: AppColors.sageGreenInk,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Mode Baca',
          onPressed: () => _openReadingModeSheet(context),
          icon: Badge(
            isLabelVisible: readingMode.isCustomized,
            smallSize: 8,
            backgroundColor: AppColors.sageGreenInk,
            child: Icon(
              Icons.text_fields_rounded,
              size: 21,
              color: isDark ? Colors.white : AppColors.ink,
            ),
          ),
        ),
        const ThemeToggleButton(),
        const SizedBox(width: 12),
      ],
    );
  }
}

class _ReadingModeBottomSheet extends ConsumerWidget {
  const _ReadingModeBottomSheet();

  static const _fontOptions = [
    (label: 'Kecil', scale: 0.9),
    (label: 'Normal', scale: 1.0),
    (label: 'Besar', scale: 1.15),
    (label: 'Fokus', scale: 1.28),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final isDark = brightness == Brightness.dark;
    final settings = ref.watch(readingModeProvider);
    final notifier = ref.read(readingModeProvider.notifier);

    final sheetBg = settings.paperTone.cardColor(brightness);
    final primaryText = isDark ? Colors.white : AppColors.ink;
    final secondaryText = isDark ? Colors.white70 : AppColors.mutedInk;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mode Baca',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: primaryText,
                ),
              ),
              if (settings.isCustomized)
                TextButton(
                  onPressed: notifier.reset,
                  child: const Text('Reset'),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // 1. Ukuran Teks
          Text(
            'Ukuran Teks',
            style: theme.textTheme.labelLarge?.copyWith(
              color: secondaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: _fontOptions.map((item) {
              final isSelected = settings.textScale == item.scale;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Semantics(
                    button: true,
                    selected: isSelected,
                    label: 'Ukuran teks ${item.label}',
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => notifier.setTextScale(item.scale),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.warmButter
                              : settings.paperTone.canvasColor(brightness),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.warmButterInk.withValues(alpha: 0.5)
                                : settings.paperTone.borderColor(brightness),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Aa',
                              textScaler: TextScaler.linear(item.scale),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? AppColors.ink : primaryText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.ink
                                    : secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // 2. Warna Kertas Baca (Mendukung Light Mode & Dark Mode)
          Text(
            'Warna Kertas Baca',
            style: theme.textTheme.labelLarge?.copyWith(
              color: secondaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: PaperTone.values.map((tone) {
              final isSelected = settings.paperTone == tone;
              final tileBg = tone.cardColor(brightness);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Semantics(
                    button: true,
                    selected: isSelected,
                    label: 'Warna kertas ${tone.label}',
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => notifier.setPaperTone(tone),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: tileBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? (isDark
                                      ? AppColors.warmButter
                                      : AppColors.ink)
                                : tone.borderColor(brightness),
                            width: isSelected ? 1.6 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isSelected) ...[
                              Icon(
                                Icons.check_circle_rounded,
                                size: 14,
                                color: isDark
                                    ? AppColors.warmButter
                                    : AppColors.ink,
                              ),
                              const SizedBox(width: 5),
                            ],
                            Flexible(
                              child: Text(
                                tone.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: primaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // 3. Mode Fokus Teks
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Mode Fokus Teks',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
            ),
            subtitle: Text(
              'Sembunyikan foto thumbnail agar daftar bacaan lebih ringkas',
              style: theme.textTheme.bodySmall?.copyWith(color: secondaryText),
            ),
            value: settings.compactMode,
            onChanged: notifier.toggleCompactMode,
          ),
        ],
      ),
    );
  }
}
