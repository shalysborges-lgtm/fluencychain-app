import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/tab_navigation_provider.dart';
import 'core/theme/app_theme.dart';
import 'data/fakes/fake_repositories.dart';
import 'domain/repositories/home_repository.dart';
import 'domain/repositories/lesson_repository.dart';
import 'domain/repositories/onboarding_repository.dart';
import 'domain/repositories/review_repository.dart';
import 'presentation/ai_tutor/controllers/chat_controller.dart';
import 'presentation/ai_tutor/screens/tutor_home_screen.dart';
import 'presentation/home/controllers/home_controller.dart';
import 'presentation/home/screens/home_screen.dart';
import 'presentation/league/screens/league_screen.dart';
import 'presentation/lesson/controllers/lesson_controller.dart';
import 'presentation/onboarding/controllers/onboarding_controller.dart';
import 'presentation/onboarding/screens/welcome_screen.dart';
import 'presentation/profile/screens/dashboard_screen.dart';
import 'presentation/review/controllers/review_controller.dart';
import 'presentation/review/screens/review_screen.dart';

/// Ponto de entrada do app (Etapa 13 — estrutura de pastas).
///
/// IMPORTANTE: os overrides abaixo usam as implementações FAKE em
/// memória (Etapa 24 — material de piloto), para que o app seja
/// 100% navegável sem depender do backend NestJS/Supabase estarem no
/// ar. Quando o backend real (Etapa 15) estiver hospedado, troque cada
/// override pela implementação real em data/repositories_impl/ — a
/// UI e os controllers (Etapa 14) não precisam mudar em nada, pois só
/// dependem dos contratos abstratos em domain/repositories/.
void main() {
  runApp(
    ProviderScope(
      overrides: [
        onboardingRepositoryProvider.overrideWithValue(FakeOnboardingRepository()),
        homeRepositoryProvider.overrideWithValue(FakeHomeRepository()),
        lessonRepositoryProvider.overrideWithValue(FakeLessonRepository()),
        reviewRepositoryProvider.overrideWithValue(FakeReviewRepository()),
        aiTutorRepositoryProvider.overrideWithValue(FakeAiTutorRepository()),
        leagueRepositoryProvider.overrideWithValue(FakeLeagueRepository()),
        dashboardRepositoryProvider.overrideWithValue(FakeDashboardRepository()),
      ],
      child: const FluencyChainApp(),
    ),
  );
}

class FluencyChainApp extends StatelessWidget {
  const FluencyChainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FluencyChain',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      // Rota inicial: onboarding. Navegação entre WelcomeScreen → Home
      // acontece via Navigator.push (Etapa 14); um roteador declarativo
      // (go_router, já em pubspec.yaml) substitui isso quando o app
      // crescer além do piloto — ver core/router/app_router.dart.
      home: const WelcomeScreen(),
    );
  }
}

/// Tab de navegação principal, usada depois que o onboarding termina.
/// Observa `currentTabIndexProvider` (atualizado pelo AppTabBar de cada
/// tela) e usa IndexedStack para preservar o estado/scroll de cada aba
/// ao trocar — evita recarregar dados toda vez que o usuário navega
/// (requisito implícito de performance, PRD seção 7).
class MainTabShell extends ConsumerWidget {
  const MainTabShell({super.key});

  static const _screens = [
    HomeScreen(),
    ReviewScreen(),
    TutorHomeScreen(),
    LeagueScreen(),
    DashboardScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(currentTabIndexProvider);
    return IndexedStack(index: index, children: _screens);
  }
}
