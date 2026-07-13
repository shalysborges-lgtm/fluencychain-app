import '../entities/curriculum.dart';

/// Contrato abstrato consumido pelo HomeController. A implementação real
/// combina cache local (Drift, offline-first — Etapa 12) com o backend
/// (`curriculum` + `progress` modules do NestJS — Etapa 13).
abstract class HomeRepository {
  /// Retorna todos os módulos disponíveis, ordenados, com os targetAreas
  /// já usados pelo controller para decidir destaque/priorização.
  Future<List<LearningModule>> getModules();

  /// Retorna as lições do módulo "corrente" do usuário (o próximo a fazer),
  /// já combinadas com o status de progresso (locked/active/done).
  Future<List<LessonRouteNode>> getCurrentModuleRoute();

  /// Retorna a missão ativa do usuário, se houver (RF05.8).
  Future<ActiveMission?> getActiveMission();

  /// Dados leves de gamificação exibidos no topo da Home (RF05.1, RF05.3).
  Future<HomeGamificationSummary> getGamificationSummary();
}

class HomeGamificationSummary {
  const HomeGamificationSummary({required this.currentStreakDays, required this.xpToday});
  final int currentStreakDays;
  final int xpToday;
}
