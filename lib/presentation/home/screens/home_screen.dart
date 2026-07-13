import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/tab_navigation_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/curriculum.dart';
import '../../lesson/screens/lesson_screen.dart';
import '../../shared_widgets/app_tab_bar.dart';
import '../controllers/home_controller.dart';
import '../widgets/jump_to_module_modal.dart';
import '../widgets/mission_card.dart';
import '../widgets/route_node.dart';

/// Tela central do app (Etapa 6 — Arquitetura da Informação, seção 3.1).
/// Responsável por: mapa de rota, missão ativa, atalho de navegação
/// não-linear ("Pular para...") e o botão flutuante "Continuar".
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.amber))
            : state.errorMessage != null
                ? _ErrorState(message: state.errorMessage!, onRetry: controller.loadHome)
                : RefreshIndicator(
                    color: AppColors.amber,
                    onRefresh: controller.loadHome,
                    child: Stack(
                      children: [
                        CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.all(AppSpacing.s4),
                              sliver: SliverToBoxAdapter(
                                child: _TopBar(
                                  streakDays: state.gamification?.currentStreakDays ?? 0,
                                  xpToday: state.gamification?.xpToday ?? 0,
                                ),
                              ),
                            ),
                            if (state.activeMission != null)
                              SliverPadding(
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                                sliver: SliverToBoxAdapter(
                                  child: MissionCard(
                                    mission: state.activeMission!,
                                    onTap: () {
                                      // Navega para a lição atual da missão —
                                      // rota real definida em app_router.dart (Etapa 13).
                                    },
                                  ),
                                ),
                              ),
                            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s6)),
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, i) {
                                    final node = state.currentRoute[i];
                                    return Column(
                                      children: [
                                        RouteNode(
                                          node: node,
                                          alignLeft: i.isOdd,
                                          onTap: node.status == LessonNodeStatus.locked
                                              ? null
                                              : () => Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) => LessonScreen(lessonId: node.lesson.id),
                                                    ),
                                                  ),
                                        ),
                                        if (i != state.currentRoute.length - 1)
                                          const RouteDivider(),
                                      ],
                                    );
                                  },
                                  childCount: state.currentRoute.length,
                                ),
                              ),
                            ),
                            const SliverToBoxAdapter(child: SizedBox(height: 100)),
                          ],
                        ),
                        Positioned(
                          right: AppSpacing.s4,
                          bottom: 70,
                          child: FloatingActionButton(
                            heroTag: 'jump-to-module',
                            backgroundColor: AppColors.ink,
                            elevation: 4,
                            onPressed: () => JumpToModuleModal.show(
                              context,
                              modules: state.modules,
                              onModuleSelected: (module) {
                                // Recarrega a rota para o módulo escolhido —
                                // implementação real dispara uma nova busca
                                // via HomeRepository filtrada por module.id.
                              },
                            ),
                            child: const Icon(Icons.alt_route, color: AppColors.amber),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
      bottomNavigationBar: AppTabBar(
        currentIndex: 0,
        onTap: (index) => ref.read(currentTabIndexProvider.notifier).state = index,
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.streakDays, required this.xpToday});
  final int streakDays;
  final int xpToday;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text('🔥', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text('$streakDays', style: AppTypography.monoMd),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.ink,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$xpToday XP',
            style: AppTypography.monoMd.copyWith(color: AppColors.paper),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: AppTypography.bodyMd, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.s4),
            TextButton(onPressed: onRetry, child: const Text('Tentar novamente')),
          ],
        ),
      ),
    );
  }
}
