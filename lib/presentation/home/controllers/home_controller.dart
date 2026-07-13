import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/curriculum.dart';
import '../../../domain/repositories/home_repository.dart';

class HomeState {
  const HomeState({
    this.modules = const [],
    this.currentRoute = const [],
    this.activeMission,
    this.gamification,
    this.isLoading = true,
    this.errorMessage,
  });

  final List<LearningModule> modules;
  final List<LessonRouteNode> currentRoute;
  final ActiveMission? activeMission;
  final HomeGamificationSummary? gamification;
  final bool isLoading;
  final String? errorMessage;

  /// O nó "active" é sempre o que o botão flutuante "Continuar" deve abrir.
  LessonRouteNode? get nextLesson {
    for (final node in currentRoute) {
      if (node.status == LessonNodeStatus.active) return node;
    }
    return null;
  }

  HomeState copyWith({
    List<LearningModule>? modules,
    List<LessonRouteNode>? currentRoute,
    ActiveMission? activeMission,
    HomeGamificationSummary? gamification,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      modules: modules ?? this.modules,
      currentRoute: currentRoute ?? this.currentRoute,
      activeMission: activeMission ?? this.activeMission,
      gamification: gamification ?? this.gamification,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class HomeController extends StateNotifier<HomeState> {
  HomeController(this._repository) : super(const HomeState()) {
    loadHome();
  }

  final HomeRepository _repository;

  Future<void> loadHome() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // Disparadas em paralelo — a Home não deve esperar uma chamada
      // terminar para começar a próxima (requisito de performance, PRD).
      final results = await Future.wait([
        _repository.getModules(),
        _repository.getCurrentModuleRoute(),
        _repository.getActiveMission(),
        _repository.getGamificationSummary(),
      ]);

      state = state.copyWith(
        modules: results[0] as List<LearningModule>,
        currentRoute: results[1] as List<LessonRouteNode>,
        activeMission: results[2] as ActiveMission?,
        gamification: results[3] as HomeGamificationSummary,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Não foi possível carregar sua trilha. Puxe para atualizar.',
      );
    }
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  throw UnimplementedError('Sobrescrever com a implementação real (Supabase + cache local)');
});

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>((ref) {
  // Mesmo padrão de injeção de dependência usado no onboarding (Etapa 14, sub-bloco 1):
  // a implementação real de HomeRepository é fornecida via override em main.dart.
  return HomeController(ref.watch(homeRepositoryProvider));
});
