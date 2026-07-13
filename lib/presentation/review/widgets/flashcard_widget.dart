import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/review_card.dart';

/// Card de revisão (Etapa 9, tela 09). Antes de virar, mostra só o termo
/// em inglês — força o Active Recall (Etapa 1, princípio pedagógico)
/// antes de revelar tradução/fonética.
class FlashcardWidget extends StatelessWidget {
  const FlashcardWidget({super.key, required this.card, required this.isFlipped, required this.onFlip});

  final ReviewCard card;
  final bool isFlipped;
  final VoidCallback onFlip;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isFlipped ? null : onFlip,
      child: Container(
        height: 220,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.line, width: 1.5),
          borderRadius: BorderRadius.circular(AppSpacing.s5),
          color: AppColors.paperCard,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isFlipped) ...[
              Text('TENTE LEMBRAR', style: AppTypography.monoSm.copyWith(color: AppColors.amberDeep)),
              const SizedBox(height: AppSpacing.s3),
              Text(card.termEn, style: AppTypography.displayMd, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.s4),
              Text('(toque para revelar)', style: AppTypography.bodySm),
            ] else ...[
              Text(card.termEn, style: AppTypography.displaySm),
              const SizedBox(height: AppSpacing.s2),
              Text(card.ipa, style: AppTypography.monoMd.copyWith(color: AppColors.teal)),
              const SizedBox(height: AppSpacing.s3),
              Text(card.termPt, style: AppTypography.bodyLg, textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}
