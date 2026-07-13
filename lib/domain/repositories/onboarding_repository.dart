import '../entities/user_profile.dart';

/// Contrato abstrato — a implementação real (Supabase + cache local)
/// fica em data/repositories_impl/, conforme Etapa 13.
abstract class OnboardingRepository {
  /// Envia o teste de nivelamento e retorna o CEFR estimado (ex: "A2").
  Future<String> submitDiagnosticTest(List<DiagnosticAnswer> answers);

  /// Persiste o perfil completo do onboarding (RF02) e marca
  /// onboarding_completed_at no backend.
  Future<void> completeOnboarding(UserProfile profile);
}

class DiagnosticAnswer {
  const DiagnosticAnswer({required this.questionId, required this.answer});
  final String questionId;
  final String answer;
}
