import '../entities/lesson_content.dart';

abstract class LessonRepository {
  /// Carrega todos os blocos de uma lição, já em ordem — inclui áudio
  /// cacheado localmente se o módulo já foi baixado (offline-first, Etapa 12).
  Future<List<LessonBlock>> getLessonBlocks(String lessonId);

  /// Envia o áudio gravado do usuário para correção de pronúncia (RF06.1).
  /// Retorna feedback rápido por palavra (síncrono, <3s conforme PRD).
  Future<PronunciationFeedback> submitPronunciation({
    required String lessonId,
    required String targetSentence,
    required List<int> audioBytes,
  });

  /// Registra a resposta de um exercício (certo/errado) — usada tanto
  /// para o quiz quanto para listening/reading.
  Future<void> submitExerciseAttempt({
    required String exerciseId,
    required String userAnswer,
    required bool isCorrect,
  });

  /// Fecha a lição: calcula XP, atualiza streak, gera flashcards novos
  /// (Etapa 7, Fluxo 2) e retorna o resumo para a tela de Resultado.
  Future<LessonResult> completeLesson(String lessonId);
}
