import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Índice da aba ativa na navegação principal (Etapa 6 — Arquitetura da
/// Informação). Cada tela chama `ref.read(currentTabIndexProvider.notifier)
/// .state = i` no `onTap` do AppTabBar; o MainTabShell (main.dart) observa
/// este provider para decidir qual tela mostrar via IndexedStack.
final currentTabIndexProvider = StateProvider<int>((ref) => 0);
