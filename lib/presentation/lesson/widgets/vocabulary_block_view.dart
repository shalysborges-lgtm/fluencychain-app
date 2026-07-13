import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/lesson_content.dart';
import '../../shared_widgets/app_button.dart';

/// Bloco de vocabulário em contexto (Etapa 7, Fluxo 2 · Etapa 9, tela 03).
class VocabularyBlockView extends StatelessWidget {
  const VocabularyBlockView({super.key, required this.content, required this.onNext});

  final VocabularyContent content;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 120,
          margin: const EdgeInsets.only(bottom: AppSpacing.s4),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.teal, AppColors.ink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.s4),
          ),
          alignment: Alignment.center,
          child: Icon(Icons.local_shipping_outlined, color: AppColors.paper.withOpacity(0.85), size: 36),
        ),
        Text(content.termEn, style: AppTypography.displayLg, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.s2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.volume_up, color: AppColors.teal),
              onPressed: () {
                // Reproduz content.audioUrl via player de áudio (Etapa 12 —
                // cache local de mídia TTS).
              },
            ),
            Text(content.ipa, style: AppTypography.monoMd.copyWith(color: AppColors.teal)),
          ],
        ),
        const SizedBox(height: AppSpacing.s3),
        Text(content.termPt, style: AppTypography.bodyMd, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.s2),
        Text(
          '"${content.exampleSentence}"',
          style: AppTypography.bodySm,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        AppButton(label: 'Próximo termo →', onPressed: onNext),
      ],
    );
  }
}
