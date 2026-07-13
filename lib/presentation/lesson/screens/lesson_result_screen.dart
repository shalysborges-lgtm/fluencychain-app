import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/lesson_content.dart';
import '../../shared_widgets/app_button.dart';
import '../widgets/manifest_card.dart';

/// Etapa 7, Fluxo 2 (Tela de Resultado) · Etapa 9, tela 05.
class LessonResultScreen extends StatelessWidget {
  const LessonResultScreen({super.key, required this.result, required this.onContinue});

  final LessonResult result;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.s6),
              Text('Lição concluída', style: AppTypography.displayMd, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.s4),
              ManifestCard(result: result),
              const SizedBox(height: AppSpacing.s3),
              Text(
                '${result.newFlashcardsCount} novos termos entraram na sua fila de revisão espaçada.',
                style: AppTypography.bodySm,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  // Abre o modal do Tutor IA sobreposto (Etapa 6, seção 3.4) —
                  // sem sair do contexto da lição concluída.
                },
                icon: const Icon(Icons.chat_bubble_outline, size: 16, color: AppColors.muted),
                label: Text('Tirar dúvida com o Tutor', style: AppTypography.bodySm),
              ),
              const SizedBox(height: AppSpacing.s2),
              AppButton(label: 'Continuar', onPressed: onContinue),
            ],
          ),
        ),
      ),
    );
  }
}
