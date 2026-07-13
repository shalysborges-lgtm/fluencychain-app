import 'package:flutter/material.dart';

/// Tokens de cor do Design System (Etapa 10).
/// Mantém os mesmos nomes semânticos usados no documento de design,
/// para que qualquer dev consiga ir e voltar entre a spec e o código.
class AppColors {
  AppColors._();

  // ---- Light mode ----
  static const Color ink = Color(0xFF12161C);
  static const Color inkSoft = Color(0xFF2A3038);
  static const Color paper = Color(0xFFF5F5F2);
  static const Color paperCard = Color(0xFFFFFFFF);
  static const Color line = Color(0xFFDEDDD6);
  static const Color amber = Color(0xFFF2A93B);
  static const Color amberDeep = Color(0xFFC97F12);
  static const Color teal = Color(0xFF1F8A70);
  static const Color danger = Color(0xFFC24A3D);
  static const Color muted = Color(0xFF767A72);

  // ---- Dark mode (Etapa 10, seção 1.2) ----
  static const Color paperDark = Color(0xFF14171C);
  static const Color paperCardDark = Color(0xFF1E2228);
  static const Color inkDark = Color(0xFFF5F5F2); // texto principal no dark
  static const Color lineDark = Color(0xFF33383F);
  static const Color tealDark = Color(0xFF2FAF8E);
  static const Color mutedDark = Color(0xFF9A9E96);

  /// amber NUNCA é invertido entre os modos — é a cor de assinatura da marca.
}
