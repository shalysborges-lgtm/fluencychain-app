import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/lesson_content.dart';
import '../../../domain/repositories/lesson_repository.dart';

class LessonState {
  const LessonState({
    this.blocks = const [],
    this.currentIndex = 0,
    this.isLoading = true,
    this.isSubmittingSpeech = false,
    this.lastFeedback,
    this.correctCount = 0,
    this.result,
    this.errorMessage,
  });

  final List<LessonBlock> blocks;
  final int currentIndex;
  final bool isLoading;
  final bool isSubmittingSpeech;
  final PronunciationFeedback? lastFeedback;
  final int correctCount;
  final LessonResult? result;
  final String? errorMessage;

  LessonBlock? get currentBlock => currentIndex < blocks.length ? blocks[currentIndex] : null;
  double get progress => blocks.isEmpty ? 0 : (currentIndex + 1) / blocks.length;
  bool get isFinished => result != null;

  LessonState copyWith({
    List<LessonBlock>? blocks,
    int? currentIndex,
    bool? isLoading,
    bool? isSubmittingSpeech,
    PronunciationFeedback? lastFeedback,
    int? correctCount,
    LessonResult? result,
    String? errorMessage,
  }) {
    return LessonState(
      blocks: blocks ?? this.blocks,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      isSubmittingSpeech: isSubmittingSpeech ?? this.isSubmittingSpeech,
      lastFeedback: lastFeedback ?? this.lastFeedback,
      correctCount: correctCount ?? this.correctCount,
      result: result ?? this.result,
      errorMessage: errorMessage,
    );
  }
}

class LessonController extends StateNotifier<LessonState> {
  LessonController(this._repository, this._lessonId) : super(const LessonState()) {
    _load();
  }

  final LessonRepository _repository;
  final String _lessonId;

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final blocks = await _repository.getLessonBlocks(_lessonId);
      state = state.copyWith(blocks: blocks, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Não foi possível carregar a lição.');
    }
  }

  /// Regra de negócio (Etapa 7, Fluxo 2): NENHUM erro bloqueia o avanço.
  /// O item errado só é sinalizado para entrar na fila de revisão espaçada
  /// no backend — o ritmo de microlearning nunca para por causa de erro.
  Future<void> submitAnswer({
    required String exerciseId,
    required String userAnswer,
    required bool isCorrect,
  }) async {
    await _repository.submitExerciseAttempt(
      exerciseId: exerciseId,
      userAnswer: userAnswer,
      isCorrect: isCorrect,
    );
    if (isCorrect) {
      state = state.copyWith(correctCount: state.correctCount + 1);
    }
    _advance();
  }

  Future<void> submitSpeech({
    required String targetSentence,
    required List<int> audioBytes,
  }) async {
    state = state.copyWith(isSubmittingSpeech: true);
    try {
      final feedback = await _repository.submitPronunciation(
        lessonId: _lessonId,
        targetSentence: targetSentence,
        audioBytes: audioBytes,
      );
      state = state.copyWith(isSubmittingSpeech: false, lastFeedback: feedback);
    } catch (e) {
      state = state.copyWith(
        isSubmittingSpeech: false,
        errorMessage: 'Não conseguimos avaliar seu áudio agora. Tente de novo.',
      );
    }
  }

  void acknowledgeSpeechAndAdvance() {
    state = state.copyWith(lastFeedback: null);
    _advance();
  }

  void skipToNextBlock() => _advance(); // usado por blocos sem exercício (ex: vocabulário)

  void _advance() {
    if (state.currentIndex >= state.blocks.length - 1) {
      _finish();
      return;
    }
    state = state.copyWith(currentIndex: state.currentIndex + 1);
  }

  Future<void> _finish() async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _repository.completeLesson(_lessonId);
      state = state.copyWith(isLoading: false, result: result);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Sua lição foi salva localmente e será sincronizada assim que possível.',
      );
    }
  }
}

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  throw UnimplementedError('Sobrescrever com a implementação real em main.dart');
});

/// family: cada tela de lição tem seu próprio controller, escopado pelo lessonId.
final lessonControllerProvider =
    StateNotifierProvider.family<LessonController, LessonState, String>((ref, lessonId) {
  return LessonController(ref.watch(lessonRepositoryProvider), lessonId);
});
