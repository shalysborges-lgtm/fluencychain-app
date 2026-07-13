/// Espelha a tabela `user_profiles` (Etapa 11).
enum StartingMode { zero, hasBase }

enum UrgencyGoal { careerGrowth, upcomingCall, upcomingInterview, justLearning }

enum ProfessionalArea { logistics, transport, supplyChain, bi, general }

class UserProfile {
  const UserProfile({
    required this.userId,
    this.displayName,
    this.professionalAreas = const [],
    this.urgencyGoal,
    this.startingMode,
    this.initialCefrEstimate,
    this.interfaceLanguage = 'pt',
    this.dailyGoalMinutes,
    this.isSprintMode = false,
    this.onboardingCompleted = false,
  });

  final String userId;
  final String? displayName;
  final List<ProfessionalArea> professionalAreas;
  final UrgencyGoal? urgencyGoal;
  final StartingMode? startingMode;
  final String? initialCefrEstimate; // ex: "A2", nulo se startingMode == zero
  final String interfaceLanguage; // 'pt' | 'en'
  final int? dailyGoalMinutes;
  final bool isSprintMode;
  final bool onboardingCompleted;

  UserProfile copyWith({
    List<ProfessionalArea>? professionalAreas,
    UrgencyGoal? urgencyGoal,
    StartingMode? startingMode,
    String? initialCefrEstimate,
    String? interfaceLanguage,
    int? dailyGoalMinutes,
    bool? isSprintMode,
    bool? onboardingCompleted,
  }) {
    return UserProfile(
      userId: userId,
      displayName: displayName,
      professionalAreas: professionalAreas ?? this.professionalAreas,
      urgencyGoal: urgencyGoal ?? this.urgencyGoal,
      startingMode: startingMode ?? this.startingMode,
      initialCefrEstimate: initialCefrEstimate ?? this.initialCefrEstimate,
      interfaceLanguage: interfaceLanguage ?? this.interfaceLanguage,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      isSprintMode: isSprintMode ?? this.isSprintMode,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}
