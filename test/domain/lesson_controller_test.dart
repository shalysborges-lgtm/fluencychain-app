import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluencychain/domain/entities/lesson_content.dart';
import 'package:fluencychain/domain/repositories/lesson_repository.dart';
import 'package:fluencychain/presentation/lesson/controllers/lesson_controller.dart';

class FakeLessonRepository implements LessonRepository {
  final List<LessonBlock> blocks;
  bool failCompletion = false;
  final List<bool> submittedCorrectness = [];

  FakeLessonRepository(this.blocks);

  @override
  Future<List<LessonBlock>> getLessonBlocks(String lessonId) async => blocks;

  @override
  Future<PronunciationFeedback> submitPronunciation({
    required String lessonId,
    required String targetSentence,
    required List<int> audioBytes,
  }) async {
    return const PronunciationFeedback(words: [
      MapEntry('lead', PhonemeScore.good),
      MapEntry('time', PhonemeScore.warning),
    ]);
  }

  @override
  Future<void> submitExerciseAttempt({
    required String exerciseId,
    required String userAnswer,
    required bool isCorrect,
  }) async {
    submittedCorrectness.add(isCorrect);
  }

  @override
  Future<LessonResult> completeLesson(String lessonId) async {
    if (failCompletion) throw Exception('sync failed');
    return const LessonResult(
      lessonCode: 'LESSON-014',
      moduleCode: 'MOD-02',
      xpEarned: 35,
      correctCount: 2,
      totalCount: 3,
      newStreakDays: 13,
      newFlashcardsCount: 5,
    );
  }
}

LessonBlock _quizBlock(String id) => LessonBlock(
      id: id,
      type: LessonBlockType.quiz,
      content: const ExerciseContent(
        promptEn: 'test prompt',
        options: [ExerciseOption(text: 'a', isCorrect: true), ExerciseOption(text: 'b', isCorrect: false)],
      ),
    );

void main() {
  test('lição avança para o próximo bloco mesmo quando a resposta está errada', () async {
    final blocks = [_quizBlock('ex-1'), _quizBlock('ex-2')];
    final repo = FakeLessonRepository(blocks);
    final container = ProviderContainer(overrides: [
      lessonRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);

    // Espera o carregamento inicial (assíncrono no construtor do controller).
    await Future<void>.delayed(Duration.zero);

    final controller = container.read(lessonControllerProvider('lesson-1').notifier);

    await controller.submitAnswer(exerciseId: 'ex-1', userAnswer: 'b', isCorrect: false);

    final state = container.read(lessonControllerProvider('lesson-1'));
    expect(state.currentIndex, 1); // avançou mesmo com erro
    expect(state.correctCount, 0); // não contou como acerto
    expect(repo.submittedCorrectness, [false]); // erro foi registrado para revisão, não bloqueou nada
  });

  test('correctCount só incrementa em respostas corretas', () async {
    final blocks = [_quizBlock('ex-1'), _quizBlock('ex-2')];
    final repo = FakeLessonRepository(blocks);
    final container = ProviderContainer(overrides: [
      lessonRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);
    await Future<void>.delayed(Duration.zero);

    final controller = container.read(lessonControllerProvider('lesson-1').notifier);
    await controller.submitAnswer(exerciseId: 'ex-1', userAnswer: 'a', isCorrect: true);

    expect(container.read(lessonControllerProvider('lesson-1')).correctCount, 1);
  });

  test('completar o último bloco chama completeLesson e popula o resultado', () async {
    final blocks = [_quizBlock('ex-1')];
    final repo = FakeLessonRepository(blocks);
    final container = ProviderContainer(overrides: [
      lessonRepositoryProvider.overrideWithValue(repo),
    ]);
    addTearDown(container.dispose);
    await Future<void>.delayed(Duration.zero);

    final controller = container.read(lessonControllerProvider('lesson-1').notifier);
    await controller.submitAnswer(exerciseId: 'ex-1', userAnswer: 'a', isCorrect: true);

    final state = container.read(lessonControllerProvider('lesson-1'));
    expect(state.result, isNotNull);
    expect(state.result!.xpEarned, 35);
    expect(state.isFinished, isTrue);
  });
}
