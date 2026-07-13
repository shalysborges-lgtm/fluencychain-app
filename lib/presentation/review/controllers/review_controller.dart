import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/review_card.dart';
import '../../../domain/repositories/review_repository.dart';

class ReviewState {
  const ReviewState({
    this.queue = const [],
    this.currentIndex = 0,
    this.isFlipped = false,
    this.isLoading = true,
    this.errorMessage,
  });

  final List<ReviewCard> queue;
  final int currentIndex;
  final bool isFlipped;
  final bool isLoading;
  final String? errorMessage;

  ReviewCard? get currentCard => currentIndex < queue.length ? queue[currentIndex] : null;
  bool get isDone => queue.isNotEmpty && currentIndex >= queue.length;
  int get remaining => (queue.length - currentIndex).clamp(0, queue.length);

  ReviewState copyWith({
    List<ReviewCard>? queue,
    int? currentIndex,
    bool? isFlipped,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ReviewState(
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Etapa 7, Fluxo 3 — Active Recall: usuário tenta lembrar ANTES de virar
/// o card, depois se autoavalia (again/hard/good/easy), que dispara o
/// recalculo SM-2 no backend (Etapa 15 — SrsService).
class ReviewController extends StateNotifier<ReviewState> {
  ReviewController(this._repository) : super(const ReviewState()) {
    _load();
  }

  final ReviewRepository _repository;

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final queue = await _repository.getDailyQueue();
      state = state.copyWith(queue: queue, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Não foi possível carregar sua fila de revisão.');
    }
  }

  void flipCard() => state = state.copyWith(isFlipped: true);

  Future<void> submitGrade(ReviewGrade grade) async {
    final card = state.currentCard;
    if (card == null) return;
    await _repository.submitGrade(card.vocabularyItemId, grade);
    state = state.copyWith(currentIndex: state.currentIndex + 1, isFlipped: false);
  }
}

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  throw UnimplementedError('Sobrescrever com a implementação real em main.dart');
});

final reviewControllerProvider = StateNotifierProvider<ReviewController, ReviewState>((ref) {
  return ReviewController(ref.watch(reviewRepositoryProvider));
});
