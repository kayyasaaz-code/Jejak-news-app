import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

/// Palet 3 Warna Utama JEJAK (Calm, Organic & Editorial)
class AppColors {
  AppColors._();

  // 1. Primary: Soft Sky Blue (#B2E4F3)
  static const Color glazeBlue = Color.fromARGB(255, 166, 224, 241);
  static const Color glazeBlueInk = Color.fromARGB(255, 22, 74, 93);

  // 2. Secondary: Fresh Mint Sage (#CBF2DA)
  static const Color sageGreen = Color(0xFFCBF2DA);
  static const Color sageGreenInk = Color(0xFF1E5638);

  // 3. Accent: Creamy Butter (#FFE39C)
  static const Color warmButter = Color(0xFFFFE39C);
  static const Color warmButterInk = Color(0xFF6B4C08);

  // Netral (Kanvas Off-White & Tinta Charcoal)
  static const Color canvas = Color(0xFFF6F6F3);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF191B1D);
  static const Color mutedInk = Color(0xFF6E737B);
  static const Color hairline = Color(0xFFE6E6E1);
}

class AppTheme {
  AppTheme._();

  // Alias kompatibilitas agar seluruh file lama tetap berjalan mulus
  static const Color freshGreen = AppColors.sageGreenInk;
  static const Color softGreen = AppColors.sageGreen;
  static const Color butterYellow = AppColors.warmButter;
  static const Color skyBlue = AppColors.glazeBlue;
  static const Color softCoral = AppColors.warmButter;
  static const Color warmWhite = AppColors.canvas;

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.glazeBlueInk,
      brightness: brightness,
      primary: isLight ? AppColors.ink : null,
      surface: isLight ? AppColors.canvas : null,
    );
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final text = base.textTheme;

    return base.copyWith(
      scaffoldBackgroundColor: isLight ? AppColors.canvas : scheme.surface,
      textTheme: text.copyWith(
        headlineMedium: text.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.7,
          color: isLight ? AppColors.ink : null,
        ),
        headlineSmall: text.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          height: 1.25,
          letterSpacing: -0.4,
          color: isLight ? AppColors.ink : null,
        ),
        titleLarge: text.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.3,
          letterSpacing: -0.2,
          color: isLight ? AppColors.ink : null,
        ),
        titleMedium: text.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: isLight ? AppColors.ink : null,
        ),
        bodyLarge: text.bodyLarge?.copyWith(height: 1.6),
      ),
      cardTheme: CardThemeData(
        color: isLight ? AppColors.cardWhite : scheme.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            color: isLight
                ? AppColors.hairline
                : scheme.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isLight ? AppColors.canvas : scheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isLight
            ? AppColors.cardWhite
            : scheme.surfaceContainer,
        elevation: 0,
        height: 70,
        indicatorColor: isLight ? AppColors.ink : scheme.secondaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: isSelected
                ? (isLight ? Colors.white : scheme.onSecondaryContainer)
                : AppColors.mutedInk,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? (isLight ? AppColors.ink : scheme.onSecondaryContainer)
                : AppColors.mutedInk,
          );
        }),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
