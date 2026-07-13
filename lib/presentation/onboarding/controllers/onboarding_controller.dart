import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/repositories/onboarding_repository.dart';

/// Estado imutável do fluxo de onboarding (RF02).
/// Cada tela do onboarding lê/atualiza este estado; nada é persistido
/// no backend até `completeOnboarding()`, exceto o teste de nivelamento
/// (que precisa de round-trip para calcular o CEFR).
class OnboardingState {
  const OnboardingState({
    this.startingMode,
    this.cefrEstimate,
    this.professionalAreas = const [],
    this.urgencyGoal,
    this.dailyGoalMinutes,
    this.isSprintMode = false,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final StartingMode? startingMode;
  final String? cefrEstimate;
  final List<ProfessionalArea> professionalAreas;
  final UrgencyGoal? urgencyGoal;
  final int? dailyGoalMinutes;
  final bool isSprintMode;
  final bool isSubmitting;
  final String? errorMessage;

  /// Regra de negócio do onboarding: só precisamos do teste de nivelamento
  /// quando o usuário disse que já tem uma base (Etapa 7, Fluxo 1).
  bool get requiresDiagnosticTest => startingMode == StartingMode.hasBase;

  OnboardingState copyWith({
    StartingMode? startingMode,
    String? cefrEstimate,
    List<ProfessionalArea>? professionalAreas,
    UrgencyGoal? urgencyGoal,
    int? dailyGoalMinutes,
    bool? isSprintMode,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return OnboardingState(
      startingMode: startingMode ?? this.startingMode,
      cefrEstimate: cefrEstimate ?? this.cefrEstimate,
      professionalAreas: professionalAreas ?? this.professionalAreas,
      urgencyGoal: urgencyGoal ?? this.urgencyGoal,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      isSprintMode: isSprintMode ?? this.isSprintMode,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController(this._repository) : super(const OnboardingState());

  final OnboardingRepository _repository;

  void selectStartingMode(StartingMode mode) {
    state = state.copyWith(startingMode: mode);
  }

  Future<void> submitDiagnosticTest(List<DiagnosticAnswer> answers) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final cefr = await _repository.submitDiagnosticTest(answers);
      state = state.copyWith(cefrEstimate: cefr, isSubmitting: false);
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Não conseguimos calcular seu nível agora. Tente novamente.',
      );
    }
  }

  void toggleProfessionalArea(ProfessionalArea area) {
    final current = [...state.professionalAreas];
    if (current.contains(area)) {
      current.remove(area);
    } else {
      current.add(area);
    }
    state = state.copyWith(professionalAreas: current);
  }

  void selectUrgencyGoal(UrgencyGoal goal) {
    // Persona Lucas (Etapa 4): entrevista/call em breve sugere sprint mode.
    final suggestsSprint =
        goal == UrgencyGoal.upcomingInterview || goal == UrgencyGoal.upcomingCall;
    state = state.copyWith(urgencyGoal: goal, isSprintMode: suggestsSprint);
  }

  void selectDailyGoal(int minutes) {
    state = state.copyWith(dailyGoalMinutes: minutes);
  }

  Future<bool> completeOnboarding(String userId) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final profile = UserProfile(
        userId: userId,
        professionalAreas: state.professionalAreas,
        urgencyGoal: state.urgencyGoal,
        startingMode: state.startingMode,
        initialCefrEstimate: state.cefrEstimate,
        dailyGoalMinutes: state.dailyGoalMinutes,
        isSprintMode: state.isSprintMode,
        onboardingCompleted: true,
      );
      await _repository.completeOnboarding(profile);
      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Não conseguimos salvar seu perfil. Verifique sua conexão.',
      );
      return false;
    }
  }
}

/// Injeção de dependência: a implementação concreta de OnboardingRepository
/// é fornecida via override em main.dart / core/di (Etapa 13).
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  throw UnimplementedError('Sobrescrever com a implementação real (Supabase) em main.dart');
});

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  return OnboardingController(ref.watch(onboardingRepositoryProvider));
});
