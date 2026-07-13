class DashboardData {
  const DashboardData({
    required this.cefrLevel,
    required this.readinessIndicators, // ex: {"S&OP meeting": 72, "Interview": 40}
    required this.vocabularyMastered,
    required this.pronunciationScoreAvg,
    required this.streakDays,
    required this.minutesStudiedThisMonth,
  });

  final String cefrLevel;
  final Map<String, int> readinessIndicators;
  final int vocabularyMastered;
  final int pronunciationScoreAvg;
  final int streakDays;
  final int minutesStudiedThisMonth;
}

/// Espelha `GET /progress/dashboard` (Etapa 16 · RF08).
abstract class DashboardRepository {
  Future<DashboardData> getDashboard();
}
