import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/tab_navigation_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/review_card.dart';
import '../../shared_widgets/app_tab_bar.dart';
import '../controllers/review_controller.dart';
import '../widgets/flashcard_widget.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reviewControllerProvider);
    final controller = ref.read(reviewControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s5),
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.amber))
              : state.queue.isEmpty
                  ? _EmptyState(onGoToLesson: () {
                      // Navega para a próxima lição da trilha (Etapa 6) —
                      // convite à ação em vez de tela vazia sem saída.
                    })
                  : state.isDone
                      ? _DoneState(reviewedCount: state.queue.length)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('${state.remaining} itens para revisar hoje', style: AppTypography.displayMd),
                            const SizedBox(height: AppSpacing.s5),
                            FlashcardWidget(
                              card: state.currentCard!,
                              isFlipped: state.isFlipped,
                              onFlip: controller.flipCard,
                            ),
                            const SizedBox(height: AppSpacing.s5),
                            if (state.isFlipped)
                              Row(
                                children: [
                                  _GradeButton(label: 'Errei', color: AppColors.danger, onTap: () => controller.submitGrade(ReviewGrade.again)),
                                  _GradeButton(label: 'Difícil', color: AppColors.amberDeep, onTap: () => controller.submitGrade(ReviewGrade.hard)),
                                  _GradeButton(label: 'Bom', color: AppColors.teal, onTap: () => controller.submitGrade(ReviewGrade.good)),
                                  _GradeButton(label: 'Fácil', color: AppColors.ink, onTap: () => controller.submitGrade(ReviewGrade.easy)),
                                ],
                              ),
                          ],
                        ),
        ),
      ),
      bottomNavigationBar: AppTabBar(
        currentIndex: 1,
        onTap: (index) => ref.read(currentTabIndexProvider.notifier).state = index,
      ),
    );
  }
}

class _GradeButton extends StatelessWidget {
  const _GradeButton({required this.label, required this.color, required this.onTap});
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.s2),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s3),
            decoration: BoxDecoration(border: Border.all(color: color, width: 1.5), borderRadius: BorderRadius.circular(AppSpacing.s2)),
            alignment: Alignment.center,
            child: Text(label, style: AppTypography.bodyMd.copyWith(color: color, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onGoToLesson});
  final VoidCallback onGoToLesson;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Nada para revisar agora.', style: AppTypography.displaySm, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.s2),
          Text('Que tal adiantar a próxima lição?', style: AppTypography.bodySm),
          const SizedBox(height: AppSpacing.s4),
          TextButton(onPressed: onGoToLesson, child: const Text('Ir para a trilha')),
        ],
      ),
    );
  }
}

class _DoneState extends StatelessWidget {
  const _DoneState({required this.reviewedCount});
  final int reviewedCount;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('✅', style: TextStyle(fontSize: 32)),
          const SizedBox(height: AppSpacing.s3),
          Text('$reviewedCount itens revisados!', style: AppTypography.displaySm),
        ],
      ),
    );
  }
}
