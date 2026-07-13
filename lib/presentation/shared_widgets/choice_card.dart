import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Cartão de opção selecionável, usado nas telas de escolha do onboarding
/// (nível de partida, área profissional, urgência/objetivo).
/// Área de toque respeita o mínimo de 44px de altura (Etapa 10, seção 5).
class ChoiceCard extends StatelessWidget {
  const ChoiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
    this.leadingEmoji,
  });

  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;
  final String? leadingEmoji;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '$title. $description',
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.s4),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          constraints: const BoxConstraints(minHeight: 64),
          padding: const EdgeInsets.all(AppSpacing.s4),
          decoration: BoxDecoration(
            color: selected ? AppColors.ink : Colors.transparent,
            border: Border.all(
              color: selected ? AppColors.ink : AppColors.line,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.s4),
          ),
          child: Row(
            children: [
              if (leadingEmoji != null) ...[
                Text(leadingEmoji!, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: AppSpacing.s3),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyLgEmphasis.copyWith(
                        color: selected ? AppColors.paper : AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: AppTypography.bodySm.copyWith(
                        color: selected ? const Color(0xFFC7C5BB) : AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
