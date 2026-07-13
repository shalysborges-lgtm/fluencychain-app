import 'dart:async';
import 'dart:math';
import '../../domain/entities/ai_tutor.dart';
import '../../domain/entities/curriculum.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/lesson_content.dart';
import '../../domain/entities/review_card.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../domain/repositories/review_repository.dart';
import '../../presentation/league/screens/league_screen.dart';

/// Implementações em memória de TODOS os contratos de repositório, usadas
/// como implementação padrão do app standalone (sem backend em produção).
/// Isso permite gerar um APK de demonstração totalmente navegável para o
/// piloto (Etapa 24) mesmo antes do backend NestJS estar hospedado.
/// Basta trocar os overrides em main.dart pelas implementações reais
/// (Supabase + NestJS, Etapa 12) quando o backend estiver no ar.

class FakeOnboardingRepository implements OnboardingRepository {
  @override
  Future<String> submitDiagnosticTest(List<DiagnosticAnswer> answers) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'B1';
  }

  @override
  Future<void> completeOnboarding(UserProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }
}

class FakeHomeRepository implements HomeRepository {
  static final _lessons = [
    const Lesson(id: 'l1', moduleId: 'm2', code: 'LESSON-011', titlePt: 'Vocabulário do CD', orderIndex: 1, scenarioContextPt: 'Seu primeiro dia no CD'),
    const Lesson(id: 'l2', moduleId: 'm2', code: 'LESSON-012', titlePt: 'Inbound e Outbound', orderIndex: 2, scenarioContextPt: 'Recebendo cargas'),
    const Lesson(id: 'l3', moduleId: 'm2', code: 'LESSON-013', titlePt: 'Picking e Packing', orderIndex: 3, scenarioContextPt: 'Separando pedidos'),
    const Lesson(id: 'l4', moduleId: 'm2', code: 'LESSON-014', titlePt: 'Cross Docking', orderIndex: 4, scenarioContextPt: 'E-mail de fornecedor'),
    const Lesson(id: 'l5', moduleId: 'm2', code: 'LESSON-015', titlePt: 'OTIF e KPIs', orderIndex: 5, scenarioContextPt: 'Reunião de indicadores'),
  ];

  @override
  Future<List<LearningModule>> getModules() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      LearningModule(id: 'm0', code: 'MOD-00', titlePt: 'Diagnóstico', orderIndex: 0, isDiagnostic: true),
      LearningModule(id: 'm1', code: 'MOD-01', titlePt: 'Inglês Básico Corporativo', orderIndex: 1),
      LearningModule(id: 'm2', code: 'MOD-02', titlePt: 'Logística', orderIndex: 2, targetProfessionalAreas: [ProfessionalArea.logistics]),
      LearningModule(id: 'm3', code: 'MOD-03', titlePt: 'Supply Chain', orderIndex: 3, targetProfessionalAreas: [ProfessionalArea.supplyChain]),
      LearningModule(id: 'm4', code: 'MOD-04', titlePt: 'Dados / BI', orderIndex: 4, targetProfessionalAreas: [ProfessionalArea.bi]),
      LearningModule(id: 'm5', code: 'MOD-05', titlePt: 'Reuniões e Soft Skills', orderIndex: 5),
      LearningModule(id: 'm6', code: 'MOD-06', titlePt: 'Entrevistas', orderIndex: 6),
      LearningModule(id: 'm7', code: 'MOD-07', titlePt: 'Simulado Final', orderIndex: 7, isFinalExam: true),
    ];
  }

  @override
  Future<List<LessonRouteNode>> getCurrentModuleRoute() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      LessonRouteNode(lesson: _lessons[0], status: LessonNodeStatus.done),
      LessonRouteNode(lesson: _lessons[1], status: LessonNodeStatus.done),
      LessonRouteNode(lesson: _lessons[2], status: LessonNodeStatus.done),
      LessonRouteNode(lesson: _lessons[3], status: LessonNodeStatus.active),
      LessonRouteNode(lesson: _lessons[4], status: LessonNodeStatus.locked),
    ];
  }

  @override
  Future<ActiveMission?> getActiveMission() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const ActiveMission(id: 'mission-1', titlePt: 'Prepare-se p/ reunião de S&OP', totalSteps: 5, currentStep: 3);
  }

  @override
  Future<HomeGamificationSummary> getGamificationSummary() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const HomeGamificationSummary(currentStreakDays: 13, xpToday: 340);
  }
}

class FakeLessonRepository implements LessonRepository {
  @override
  Future<List<LessonBlock>> getLessonBlocks(String lessonId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const [
      LessonBlock(
        id: 'block-vocab',
        type: LessonBlockType.vocabulary,
        content: VocabularyContent(
          termEn: 'Cross Docking',
          termPt: 'Transferência direta de carga, sem armazenagem',
          ipa: '/krɒs ˈdɒkɪŋ/',
          audioUrl: '',
          exampleSentence: 'We use cross docking to reduce storage costs.',
        ),
      ),
      LessonBlock(
        id: 'block-listening',
        type: LessonBlockType.listening,
        content: ExerciseContent(
          promptEn: 'What happens to the fast-moving SKUs starting next week?',
          audioUrl: 'audio://placeholder',
          options: [
            ExerciseOption(text: 'They go straight from inbound to outbound trucks', isCorrect: true),
            ExerciseOption(text: 'They are stored for two weeks', isCorrect: false),
          ],
        ),
      ),
      LessonBlock(
        id: 'block-reading',
        type: LessonBlockType.reading,
        content: ExerciseContent(
          promptEn: 'According to the e-mail, what is the expected benefit?',
          options: [
            ExerciseOption(text: 'Reduced average lead time', isCorrect: true),
            ExerciseOption(text: 'Lower fill rate', isCorrect: false),
          ],
        ),
      ),
      LessonBlock(
        id: 'block-speaking',
        type: LessonBlockType.speaking,
        content: SpeakingContent(targetSentence: 'We use cross docking to reduce storage costs and lead time.'),
      ),
      LessonBlock(
        id: 'block-writing',
        type: LessonBlockType.writing,
        content: ExerciseContent(
          promptEn: '"Please make sure the receiving staff is ___ about the new process."',
          options: [
            ExerciseOption(text: 'briefed', isCorrect: true),
            ExerciseOption(text: 'brief', isCorrect: false),
          ],
        ),
      ),
      LessonBlock(
        id: 'block-quiz',
        type: LessonBlockType.quiz,
        content: ExerciseContent(
          promptEn: 'What is cross docking?',
          options: [
            ExerciseOption(text: 'Transferring goods directly, without storage', isCorrect: true),
            ExerciseOption(text: 'A type of safety stock', isCorrect: false),
          ],
        ),
      ),
    ];
  }

  @override
  Future<PronunciationFeedback> submitPronunciation({
    required String lessonId,
    required String targetSentence,
    required List<int> audioBytes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final words = targetSentence.split(' ').take(6);
    final scores = [PhonemeScore.good, PhonemeScore.good, PhonemeScore.warning];
    final rand = Random();
    return PronunciationFeedback(
      words: words.map((w) => MapEntry(w, scores[rand.nextInt(scores.length)])).toList(),
    );
  }

  @override
  Future<void> submitExerciseAttempt({required String exerciseId, required String userAnswer, required bool isCorrect}) async {
    await Future.delayed(const Duration(milliseconds: 150));
  }

  @override
  Future<LessonResult> completeLesson(String lessonId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const LessonResult(
      lessonCode: 'LESSON-014',
      moduleCode: 'MOD-02',
      xpEarned: 35,
      correctCount: 5,
      totalCount: 6,
      newStreakDays: 14,
      newFlashcardsCount: 5,
    );
  }
}

class FakeReviewRepository implements ReviewRepository {
  @override
  Future<List<ReviewCard>> getDailyQueue() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      ReviewCard(vocabularyItemId: 'v1', termEn: 'Fill Rate', termPt: 'Taxa de atendimento de pedidos', ipa: '/fɪl reɪt/'),
      ReviewCard(vocabularyItemId: 'v2', termEn: 'Lead Time', termPt: 'Tempo entre pedido e entrega', ipa: '/liːd taɪm/'),
      ReviewCard(vocabularyItemId: 'v3', termEn: 'Safety Stock', termPt: 'Estoque de segurança', ipa: '/ˈseɪfti stɒk/'),
    ];
  }

  @override
  Future<void> submitGrade(String vocabularyItemId, ReviewGrade grade) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

class FakeAiTutorRepository implements AiTutorRepository {
  @override
  Future<ChatMessage> sendChatMessage(List<ChatMessage> history, String newMessage) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const ChatMessage(
      role: ChatRole.assistant,
      text: "Good question! In logistics, we'd usually say \"lead time\" for that — want to practice a sentence with it?",
    );
  }

  @override
  List<SimulationOption> getAvailableSimulations() => const [
        SimulationOption(type: SimulationType.interview, titlePt: 'Simulação de Entrevista', scenarioCode: 'GENERIC_INTERVIEW'),
        SimulationOption(type: SimulationType.meeting, titlePt: 'Simulação de Reunião (S&OP)', scenarioCode: 'SOP_MEETING'),
        SimulationOption(type: SimulationType.presentation, titlePt: 'Simulação de Apresentação', scenarioCode: 'DASHBOARD_PRESENTATION'),
      ];
}

class FakeLeagueRepository implements LeagueRepository {
  @override
  Future<List<LeagueEntry>> getCurrentLeagueEntries() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      LeagueEntry(rank: 1, name: 'Camila A.', weeklyXp: 420, isCurrentUser: false),
      LeagueEntry(rank: 2, name: 'Você', weeklyXp: 380, isCurrentUser: true),
      LeagueEntry(rank: 3, name: 'Rodrigo F.', weeklyXp: 350, isCurrentUser: false),
      LeagueEntry(rank: 4, name: 'Lucas M.', weeklyXp: 310, isCurrentUser: false),
      LeagueEntry(rank: 5, name: 'Fernanda L.', weeklyXp: 290, isCurrentUser: false),
    ];
  }

  @override
  Future<String> getCurrentTierName() async => 'Ouro';
}

class FakeDashboardRepository implements DashboardRepository {
  @override
  Future<DashboardData> getDashboard() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const DashboardData(
      cefrLevel: 'B1 → B1+',
      readinessIndicators: {'reunião de S&OP': 72, 'entrevista de emprego': 40},
      vocabularyMastered: 210,
      pronunciationScoreAvg: 82,
      streakDays: 13,
      minutesStudiedThisMonth: 380,
    );
  }
}
