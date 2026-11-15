import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pilihan nuansa kertas baca yang mendukung Light Mode & Dark Mode.
enum PaperTone {
  clean(
    label: 'Netral',
    lightCard: Color(0xFFFFFFFF),
    lightCanvas: Color(0xFFF6F6F3),
    darkCard: Color(0xFF1E2025),
    darkCanvas: Color(0xFF121417),
  ),
  warm(
    label: 'Sepia Hangat',
    lightCard: Color(0xFFF6EFE2),
    lightCanvas: Color(0xFFEDE3D2),
    darkCard: Color(0xFF28221C),
    darkCanvas: Color(0xFF1C1713),
  ),
  sage(
    label: 'Hijau Teduh',
    lightCard: Color(0xFFEAF2EC),
    lightCanvas: Color(0xFFDCE8DF),
    darkCard: Color(0xFF1B2620),
    darkCanvas: Color(0xFF121A16),
  );

  const PaperTone({
    required this.label,
    required this.lightCard,
    required this.lightCanvas,
    required this.darkCard,
    required this.darkCanvas,
  });

  final String label;
  final Color lightCard;
  final Color lightCanvas;
  final Color darkCard;
  final Color darkCanvas;

  Color cardColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkCard : lightCard;

  Color canvasColor(Brightness brightness) =>
      brightness == Brightness.dark ? darkCanvas : lightCanvas;

  Color borderColor(Brightness brightness) => brightness == Brightness.dark
      ? Colors.white.withValues(alpha: 0.12)
      : const Color(0xFF191B1D).withValues(alpha: 0.10);
}

@immutable
class ReadingModeSettings {
  const ReadingModeSettings({
    this.textScale = 1.0,
    this.paperTone = PaperTone.clean,
    this.compactMode = false,
  });

  final double textScale;
  final PaperTone paperTone;
  final bool compactMode;

  bool get isCustomized =>
      textScale != 1.0 || paperTone != PaperTone.clean || compactMode;

  ReadingModeSettings copyWith({
    double? textScale,
    PaperTone? paperTone,
    bool? compactMode,
  }) {
    return ReadingModeSettings(
      textScale: textScale ?? this.textScale,
      paperTone: paperTone ?? this.paperTone,
      compactMode: compactMode ?? this.compactMode,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadingModeSettings &&
          runtimeType == other.runtimeType &&
          textScale == other.textScale &&
          paperTone == other.paperTone &&
          compactMode == other.compactMode;

  @override
  int get hashCode => Object.hash(textScale, paperTone, compactMode);
}

class ReadingModeNotifier extends Notifier<ReadingModeSettings> {
  static const _keyScale = 'reading_text_scale';
  static const _keyTone = 'reading_paper_tone';
  static const _keyCompact = 'reading_compact_mode';

  @override
  ReadingModeSettings build() {
    _loadFromPrefs();
    return const ReadingModeSettings();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final scale = prefs.getDouble(_keyScale) ?? 1.0;
    final toneIndex = prefs.getInt(_keyTone) ?? 0;
    final compact = prefs.getBool(_keyCompact) ?? false;

    final safeTone = (toneIndex >= 0 && toneIndex < PaperTone.values.length)
        ? PaperTone.values[toneIndex]
        : PaperTone.clean;

    state = ReadingModeSettings(
      textScale: scale,
      paperTone: safeTone,
      compactMode: compact,
    );
  }

  Future<void> setTextScale(double scale) async {
    state = state.copyWith(textScale: scale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyScale, scale);
  }

  Future<void> setPaperTone(PaperTone tone) async {
    state = state.copyWith(paperTone: tone);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTone, tone.index);
  }

  Future<void> toggleCompactMode(bool value) async {
    state = state.copyWith(compactMode: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCompact, value);
  }

  Future<void> reset() async {
    state = const ReadingModeSettings();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyScale);
    await prefs.remove(_keyTone);
    await prefs.remove(_keyCompact);
  }
}

final readingModeProvider =
    NotifierProvider<ReadingModeNotifier, ReadingModeSettings>(
      ReadingModeNotifier.new,
    );
