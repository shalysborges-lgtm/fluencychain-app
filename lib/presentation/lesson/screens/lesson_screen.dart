import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/lesson_content.dart';
import '../controllers/lesson_controller.dart';
import '../widgets/exercise_block_view.dart';
import '../widgets/speaking_block_view.dart';
import '../widgets/vocabulary_block_view.dart';
import 'lesson_result_screen.dart';

/// Orquestra os 6 blocos de uma lição (Etapa 7, Fluxo 2). Cada bloco é
/// "burro" (só UI) — toda a lógica de avanço, XP e regra de "erro nunca
/// bloqueia" vive no LessonController.
class LessonScreen extends ConsumerWidget {
  const LessonScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lessonControllerProvider(lessonId));
    final controller = ref.read(lessonControllerProvider(lessonId).notifier);

    if (state.isLoading && state.blocks.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.paper,
        body: Center(child: CircularProgressIndicator(color: AppColors.amber)),
      );
    }

    if (state.result != null) {
      return LessonResultScreen(
        result: state.result!,
        onContinue: () => Navigator.of(context).popUntil((r) => r.isFirst),
      );
    }

    final block = state.currentBlock;
    if (block == null) {
      return const Scaffold(backgroundColor: AppColors.paper, body: SizedBox());
    }

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.ink),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: state.progress,
                        minHeight: 6,
                        backgroundColor: AppColors.line,
                        color: AppColors.amber,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s5),
              Expanded(child: _buildBlock(block, state, controller)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlock(LessonBlock block, LessonState state, LessonController controller) {
    switch (block.type) {
      case LessonBlockType.vocabulary:
        return VocabularyBlockView(
          content: block.content as VocabularyContent,
          onNext: controller.skipToNextBlock,
        );

      case LessonBlockType.listening:
      case LessonBlockType.reading:
      case LessonBlockType.quiz:
        final title = switch (block.type) {
          LessonBlockType.listening => 'Ouça e responda',
          LessonBlockType.reading => 'Leia e responda',
          _ => 'Quiz rápido',
        };
        return ExerciseBlockView(
          exerciseId: block.id,
          content: block.content as ExerciseContent,
          title: title,
          onAnswered: (exerciseId, answer, isCorrect) => controller.submitAnswer(
            exerciseId: exerciseId,
            userAnswer: answer,
            isCorrect: isCorrect,
          ),
        );

      case LessonBlockType.speaking:
        final content = block.content as SpeakingContent;
        return SpeakingBlockView(
          content: content,
          isSubmitting: state.isSubmittingSpeech,
          feedback: state.lastFeedback,
          onRecordingComplete: (bytes) => controller.submitSpeech(
            targetSentence: content.targetSentence,
            audioBytes: bytes,
          ),
          onContinue: controller.acknowledgeSpeechAndAdvance,
        );

      case LessonBlockType.writing:
        // Reaproveita o mesmo componente de exercício — writing no MVP é
        // "completar frase" com opções (fill_blank), conforme Etapa 11.
        return ExerciseBlockView(
          exerciseId: block.id,
          content: block.content as ExerciseContent,
          title: 'Complete a frase',
          onAnswered: (exerciseId, answer, isCorrect) => controller.submitAnswer(
            exerciseId: exerciseId,
            userAnswer: answer,
            isCorrect: isCorrect,
          ),
        );
    }
  }
}
