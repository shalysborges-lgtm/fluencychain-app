import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Monta os ThemeData de light/dark mode a partir dos tokens do Design
/// System (Etapa 10). Widgets NÃO devem referenciar cores/fontes soltas —
/// sempre via Theme.of(context) ou os tokens em AppColors/AppTypography.
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.paper,
        colorScheme: const ColorScheme.light(
          primary: AppColors.amber,
          secondary: AppColors.teal,
          error: AppColors.danger,
          surface: AppColors.paperCard,
        ),
        textTheme: const TextTheme(
          displayLarge: AppTypography.displayLg,
          displayMedium: AppTypography.displayMd,
          displaySmall: AppTypography.displaySm,
          bodyLarge: AppTypography.bodyLg,
          bodyMedium: AppTypography.bodyMd,
          bodySmall: AppTypography.bodySm,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.ink,
            foregroundColor: AppColors.paper,
            minimumSize: const Size.fromHeight(52),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            textStyle: AppTypography.bodyLgEmphasis.copyWith(color: AppColors.paper),
          ),
        ),
        dividerColor: AppColors.line,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.paperDark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.amber, // amber nunca é invertido (Etapa 10)
          secondary: AppColors.tealDark,
          error: AppColors.danger,
          surface: AppColors.paperCardDark,
        ),
        textTheme: TextTheme(
          displayLarge: AppTypography.displayLg.copyWith(color: AppColors.inkDark),
          displayMedium: AppTypography.displayMd.copyWith(color: AppColors.inkDark),
          displaySmall: AppTypography.displaySm.copyWith(color: AppColors.inkDark),
          bodyLarge: AppTypography.bodyLg.copyWith(color: AppColors.inkDark),
          bodyMedium: AppTypography.bodyMd.copyWith(color: AppColors.inkDark),
          bodySmall: AppTypography.bodySm.copyWith(color: AppColors.mutedDark),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.amber,
            foregroundColor: AppColors.ink,
            minimumSize: const Size.fromHeight(52),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
        dividerColor: AppColors.lineDark,
      );
}
