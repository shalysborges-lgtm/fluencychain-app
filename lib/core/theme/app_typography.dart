import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Escala tipográfica do Design System (Etapa 10, seção 1.3).
/// Requer as fontes Space Grotesk, Inter e IBM Plex Mono registradas
/// em pubspec.yaml (google_fonts ou assets locais).
class AppTypography {
  AppTypography._();

  static const String _display = 'SpaceGrotesk';
  static const String _body = 'Inter';
  static const String _mono = 'IBMPlexMono';

  static const TextStyle displayLg = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w700,
    fontSize: 28,
    color: AppColors.ink,
    height: 1.15,
  );

  static const TextStyle displayMd = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: AppColors.ink,
    height: 1.2,
  );

  static const TextStyle displaySm = TextStyle(
    fontFamily: _display,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: AppColors.ink,
    height: 1.25,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w400,
    fontSize: 15,
    color: AppColors.ink,
    height: 1.4,
  );

  static const TextStyle bodyLgEmphasis = TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: AppColors.ink,
    height: 1.4,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w500,
    fontSize: 13,
    color: AppColors.ink,
    height: 1.4,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: _body,
    fontWeight: FontWeight.w400,
    fontSize: 11.5,
    color: AppColors.muted,
    height: 1.4,
  );

  static const TextStyle monoMd = TextStyle(
    fontFamily: _mono,
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: AppColors.ink,
    letterSpacing: 0.2,
  );

  static const TextStyle monoSm = TextStyle(
    fontFamily: _mono,
    fontWeight: FontWeight.w500,
    fontSize: 10,
    color: AppColors.muted,
    letterSpacing: 0.6,
  );
}
