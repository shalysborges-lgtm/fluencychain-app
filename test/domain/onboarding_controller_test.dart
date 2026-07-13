import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluencychain/domain/entities/user_profile.dart';
import 'package:fluencychain/domain/repositories/onboarding_repository.dart';
import 'package:fluencychain/presentation/onboarding/controllers/onboarding_controller.dart';

/// Fake em memória — não usa mocks pesados para manter os testes de
/// domínio rápidos e sem dependência de infraestrutura (Etapa 21,
/// princípio de pirâmide de testes: muitos testes de unidade rápidos).
class FakeOnboardingRepository implements OnboardingRepository {
  bool shouldFail = false;
  UserProfile? lastCompletedProfile;

  @override
  Future<String> submitDiagnosticTest(List<DiagnosticAnswer> answers) async {
    if (shouldFail) throw Exception('network error');
    return 'B1';
  }

  @override
  Future<void> completeOnboarding(UserProfile profile) async {
    if (shouldFail) throw Exception('network error');
    lastCompletedProfile = profile;
  }
}

void main() {
  late FakeOnboardingRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeOnboardingRepository();
    container = ProviderContainer(overrides: [
      onboardingRepositoryProvider.overrideWithValue(repository),
    ]);
  });

  tearDown(() => container.dispose());

  test('requiresDiagnosticTest é true apenas quando startingMode = hasBase', () {
    final controller = container.read(onboardingControllerProvider.notifier);

    controller.selectStartingMode(StartingMode.zero);
    expect(container.read(onboardingControllerProvider).requiresDiagnosticTest, isFalse);

    controller.selectStartingMode(StartingMode.hasBase);
    expect(container.read(onboardingControllerProvider).requiresDiagnosticTest, isTrue);
  });

  test('selecionar urgência "entrevista em breve" ativa isSprintMode automaticamente', () {
    final controller = container.read(onboardingControllerProvider.notifier);

    controller.selectUrgencyGoal(UrgencyGoal.upcomingInterview);

    expect(container.read(onboardingControllerProvider).isSprintMode, isTrue);
  });

  test('selecionar urgência "crescer na carreira" NÃO ativa sprint mode', () {
    final controller = container.read(onboardingControllerProvider.notifier);

    controller.selectUrgencyGoal(UrgencyGoal.careerGrowth);

    expect(container.read(onboardingControllerProvider).isSprintMode, isFalse);
  });

  test('toggleProfessionalArea adiciona e remove corretamente (multi-select)', () {
    final controller = container.read(onboardingControllerProvider.notifier);

    controller.toggleProfessionalArea(ProfessionalArea.logistics);
    controller.toggleProfessionalArea(ProfessionalArea.bi);
    expect(
      container.read(onboardingControllerProvider).professionalAreas,
      containsAll([ProfessionalArea.logistics, ProfessionalArea.bi]),
    );

    controller.toggleProfessionalArea(ProfessionalArea.logistics);
    expect(
      container.read(onboardingControllerProvider).professionalAreas,
      isNot(contains(ProfessionalArea.logistics)),
    );
  });

  test('completeOnboarding envia o perfil completo ao repositório e retorna true', () async {
    final controller = container.read(onboardingControllerProvider.notifier);
    controller.selectStartingMode(StartingMode.zero);
    controller.toggleProfessionalArea(ProfessionalArea.logistics);
    controller.selectUrgencyGoal(UrgencyGoal.careerGrowth);
    controller.selectDailyGoal(15);

    final success = await controller.completeOnboarding('user-123');

    expect(success, isTrue);
    expect(repository.lastCompletedProfile?.userId, 'user-123');
    expect(repository.lastCompletedProfile?.dailyGoalMinutes, 15);
  });

  test('completeOnboarding retorna false e expõe erro quando o repositório falha', () async {
    repository.shouldFail = true;
    final controller = container.read(onboardingControllerProvider.notifier);

    final success = await controller.completeOnboarding('user-123');

    expect(success, isFalse);
    expect(container.read(onboardingControllerProvider).errorMessage, isNotNull);
  });
}
