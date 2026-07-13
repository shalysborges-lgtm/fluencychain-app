import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/lesson_content.dart';
import '../../shared_widgets/choice_card.dart';

/// Bloco de múltipla escolha, reutilizado para listening, reading e quiz
/// (Etapa 7, Fluxo 2). Se `content.audioUrl` existir, mostra o player —
/// é isso que diferencia visualmente um bloco de listening de um de reading.
class ExerciseBlockView extends StatefulWidget {
  const ExerciseBlockView({
    super.key,
    required this.exerciseId,
    required this.content,
    required this.title,
    required this.onAnswered,
  });

  final String exerciseId;
  final ExerciseContent content;
  final String title;

  /// isCorrect nunca bloqueia o fluxo — quem decide o avanço é a tela pai,
  /// que sempre chama controller.submitAnswer independente do resultado.
  final void Function(String exerciseId, String answerText, bool isCorrect) onAnswered;

  @override
  State<ExerciseBlockView> createState() => _ExerciseBlockViewState();
}

class _ExerciseBlockViewState extends State<ExerciseBlockView> {
  int? _selected;
  bool _answered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.title, style: AppTypography.displaySm),
        const SizedBox(height: AppSpacing.s4),
        if (widget.content.audioUrl != null)
          Container(
            height: 60,
            margin: const EdgeInsets.only(bottom: AppSpacing.s4),
            decoration: BoxDecoration(
              color: AppColors.paperCard,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(AppSpacing.s3),
            ),
            child: Row(
              children: [
                const SizedBox(width: AppSpacing.s3),
                const Icon(Icons.play_circle_fill, color: AppColors.teal, size: 28),
                const SizedBox(width: AppSpacing.s2),
                Text('Ouvir áudio', style: AppTypography.bodyMd),
              ],
            ),
          ),
        Text(widget.content.promptEn, style: AppTypography.bodyLg),
        const SizedBox(height: AppSpacing.s4),
        ...List.generate(widget.content.options.length, (i) {
          final option = widget.content.options[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s2),
            child: ChoiceCard(
              title: option.text,
              description: '',
              selected: _selected == i,
              onTap: _answered ? () {} : () => _selectAndSubmit(i, option),
            ),
          );
        }),
      ],
    );
  }

  void _selectAndSubmit(int index, ExerciseOption option) {
    setState(() {
      _selected = index;
      _answered = true;
    });
    // Pequeno delay só para o usuário ver a seleção antes de avançar —
    // motion coerente com Etapa 10, seção 4 (feedback sempre visível).
    Future.delayed(const Duration(milliseconds: 350), () {
      widget.onAnswered(widget.exerciseId, option.text, option.isCorrect);
    });
  }
}
