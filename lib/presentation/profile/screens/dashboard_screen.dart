import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/tab_navigation_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/dashboard_data.dart';
import '../../shared_widgets/app_tab_bar.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  throw UnimplementedError('Sobrescrever com a implementação real em main.dart');
});

final dashboardProvider = FutureProvider<DashboardData>((ref) {
  return ref.watch(dashboardRepositoryProvider).getDashboard();
});

/// Etapa 6, seção 5 — dashboard em camadas: streak/XP sempre visível
/// primeiro (aqui delegado ao cabeçalho do Perfil, fora deste arquivo),
/// indicadores "Pronto para..." logo depois, detalhamento por último.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: dataAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.amber)),
          error: (e, _) => Center(child: Text('Não foi possível carregar seu progresso.', style: AppTypography.bodySm)),
          data: (data) => ListView(
            padding: const EdgeInsets.all(AppSpacing.s5),
            children: [
              Text('Sua evolução', style: AppTypography.displayMd),
              const SizedBox(height: AppSpacing.s2),
              Text('Nível estimado: ${data.cefrLevel}', style: AppTypography.bodyMd),
              const SizedBox(height: AppSpacing.s5),
              ...data.readinessIndicators.entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Pronto para: ${entry.key}', style: AppTypography.bodyMd),
                            Text('${entry.value}%', style: AppTypography.monoMd),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.s2),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: entry.value / 100,
                            minHeight: 6,
                            backgroundColor: const Color(0xFFEAE9E4),
                            color: AppColors.amber,
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: AppSpacing.s3),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: AppSpacing.s2,
                mainAxisSpacing: AppSpacing.s2,
                childAspectRatio: 1.6,
                children: [
                  _StatCard(value: '${data.vocabularyMastered}', label: 'TERMOS DOMINADOS'),
                  _StatCard(value: '${data.pronunciationScoreAvg}%', label: 'SCORE PRONÚNCIA'),
                  _StatCard(value: '${data.streakDays}d', label: 'STREAK ATUAL'),
                  _StatCard(value: '${data.minutesStudiedThisMonth}min', label: 'ESTUDADO NO MÊS'),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppTabBar(
        currentIndex: 4,
        onTap: (index) => ref.read(currentTabIndexProvider.notifier).state = index,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s3),
      decoration: BoxDecoration(border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(AppSpacing.s3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: AppTypography.displaySm),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.monoSm),
        ],
      ),
    );
  }
}
