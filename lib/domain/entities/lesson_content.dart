/// Espelha `lesson_blocks` + `exercises` (Etapa 11). Um bloco por etapa
/// da lição (Etapa 7, Fluxo 2): vocabulary, listening, reading, speaking,
/// writing, quiz.
enum LessonBlockType { vocabulary, listening, reading, speaking, writing, quiz }

class LessonBlock {
  const LessonBlock({
    required this.id,
    required this.type,
    required this.content,
  });

  final String id;
  final LessonBlockType type;

  /// Conteúdo específico do bloco. Ex.: vocabulary -> VocabularyContent,
  /// listening/reading/quiz -> ExerciseContent, speaking -> SpeakingContent.
  final Object content;
}

class VocabularyContent {
  const VocabularyContent({
    required this.termEn,
    required this.termPt,
    required this.ipa,
    required this.audioUrl,
    required this.exampleSentence,
  });

  final String termEn;
  final String termPt;
  final String ipa;
  final String audioUrl;
  final String exampleSentence;
}

class ExerciseOption {
  const ExerciseOption({required this.text, required this.isCorrect});
  final String text;
  final bool isCorrect;
}

class ExerciseContent {
  const ExerciseContent({
    required this.promptEn,
    required this.options,
    this.audioUrl,
  });

  final String promptEn;
  final List<ExerciseOption> options;
  final String? audioUrl; // presente em blocos de listening
}

class SpeakingContent {
  const SpeakingContent({required this.targetSentence});
  final String targetSentence;
}

/// Resultado de um item de fonema após correção de pronúncia (RF06.1).
enum PhonemeScore { good, warning, bad }

class PronunciationFeedback {
  const PronunciationFeedback({required this.words});
  final List<MapEntry<String, PhonemeScore>> words;
}

/// Resumo final da lição, usado na tela de Resultado / cartão-manifesto.
class LessonResult {
  const LessonResult({
    required this.lessonCode,
    required this.moduleCode,
    required this.xpEarned,
    required this.correctCount,
    required this.totalCount,
    required this.newStreakDays,
    required this.newFlashcardsCount,
  });

  final String lessonCode;
  final String moduleCode;
  final int xpEarned;
  final int correctCount;
  final int totalCount;
  final int newStreakDays;
  final int newFlashcardsCount;
}
