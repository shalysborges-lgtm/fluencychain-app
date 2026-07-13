import 'user_profile.dart';

/// Espelha a tabela `modules` (Etapa 11).
class LearningModule {
  const LearningModule({
    required this.id,
    required this.code,
    required this.titlePt,
    required this.orderIndex,
    this.isDiagnostic = false,
    this.isFinalExam = false,
    this.targetProfessionalAreas = const [],
    this.recommendedPrerequisiteModuleId,
  });

  final String id;
  final String code; // ex: "MOD-02"
  final String titlePt;
  final int orderIndex;
  final bool isDiagnostic;
  final bool isFinalExam;
  final List<ProfessionalArea> targetProfessionalAreas;
  final String? recommendedPrerequisiteModuleId;
}

/// Espelha a tabela `lessons` (Etapa 11).
class Lesson {
  const Lesson({
    required this.id,
    required this.moduleId,
    required this.code,
    required this.titlePt,
    required this.orderIndex,
    required this.scenarioContextPt,
    this.estimatedDurationSeconds = 240,
  });

  final String id;
  final String moduleId;
  final String code; // ex: "LESSON-014", usado no cartão-manifesto
  final String titlePt;
  final int orderIndex;
  final String scenarioContextPt;
  final int estimatedDurationSeconds;
}

/// Status visual de um nó na trilha (Etapa 10, seção 3.3).
enum LessonNodeStatus { locked, active, done }

/// Modelo de apresentação: uma lição já combinada com o progresso do
/// usuário, pronta para renderizar um `RouteNode` na Home.
class LessonRouteNode {
  const LessonRouteNode({
    required this.lesson,
    required this.status,
  });

  final Lesson lesson;
  final LessonNodeStatus status;
}

/// Espelha `missions` + `user_missions` (Etapa 11), já resolvido para
/// exibição no card de missão ativa da Home.
class ActiveMission {
  const ActiveMission({
    required this.id,
    required this.titlePt,
    required this.totalSteps,
    required this.currentStep,
  });

  final String id;
  final String titlePt;
  final int totalSteps;
  final int currentStep;
}
