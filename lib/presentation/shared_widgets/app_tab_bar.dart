import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Bottom navigation de 5 abas (Etapa 6 — Arquitetura da Informação;
/// Etapa 10, seção 3.10). Item ativo: peso 700 + ponto indicador.
class AppTabItem {
  const AppTabItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class AppTabBar extends StatelessWidget {
  const AppTabBar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<AppTabItem> items = [
    AppTabItem(icon: Icons.route_outlined, label: 'TRILHA'),
    AppTabItem(icon: Icons.refresh, label: 'REVISÃO'),
    AppTabItem(icon: Icons.smart_toy_outlined, label: 'TUTOR'),
    AppTabItem(icon: Icons.emoji_events_outlined, label: 'LIGA'),
    AppTabItem(icon: Icons.person_outline, label: 'PERFIL'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.line, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final bool active = i == currentIndex;
          final item = items[i];
          return InkWell(
            onTap: () => onTap(i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, size: 20, color: active ? AppColors.ink : AppColors.muted),
                const SizedBox(height: 3),
                Text(
                  item.label,
                  style: AppTypography.monoSm.copyWith(
                    color: active ? AppColors.ink : AppColors.muted,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                if (active) ...[
                  const SizedBox(height: 2),
                  Container(width: 4, height: 4, decoration: const BoxDecoration(
                    color: AppColors.ink, shape: BoxShape.circle,
                  )),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}
