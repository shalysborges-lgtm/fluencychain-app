import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/tab_navigation_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../shared_widgets/app_tab_bar.dart';

class LeagueEntry {
  const LeagueEntry({required this.rank, required this.name, required this.weeklyXp, required this.isCurrentUser});
  final int rank;
  final String name;
  final int weeklyXp;
  final bool isCurrentUser;
}

/// Contrato simplificado — espelha `GET /leagues/me` (Etapa 16).
abstract class LeagueRepository {
  Future<List<LeagueEntry>> getCurrentLeagueEntries();
  Future<String> getCurrentTierName();
}

final leagueRepositoryProvider = Provider<LeagueRepository>((ref) {
  throw UnimplementedError('Sobrescrever com a implementação real em main.dart');
});

final leagueEntriesProvider = FutureProvider<List<LeagueEntry>>((ref) {
  return ref.watch(leagueRepositoryProvider).getCurrentLeagueEntries();
});

final leagueTierNameProvider = FutureProvider<String>((ref) {
  return ref.watch(leagueRepositoryProvider).getCurrentTierName();
});

/// RF05.4 — ranking semanal. Promoção/rebaixamento é decidido no backend
/// (LeaguesService, Etapa 15) — esta tela só exibe o estado atual.
class LeagueScreen extends ConsumerWidget {
  const LeagueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(leagueEntriesProvider);
    final tierAsync = ref.watch(leagueTierNameProvider);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Liga ${tierAsync.value ?? ''}', style: AppTypography.displayMd),
              const SizedBox(height: AppSpacing.s2),
              Text('Top 10 sobe, últimos 5 descem', style: AppTypography.bodySm),
              const SizedBox(height: AppSpacing.s4),
              Expanded(
                child: entriesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.amber)),
                  error: (e, _) => Center(child: Text('Não foi possível carregar a liga.', style: AppTypography.bodySm)),
                  data: (entries) => ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const Divider(color: AppColors.line, height: 1),
                    itemBuilder: (context, i) {
                      final entry = entries[i];
                      final isPromotionZone = entry.rank <= 10;
                      final isDemotionZone = entry.rank > entries.length - 5;
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s3),
                        decoration: entry.isCurrentUser
                            ? BoxDecoration(color: AppColors.amber.withOpacity(0.12), borderRadius: BorderRadius.circular(AppSpacing.s2))
                            : null,
                        child: Row(children: [
                          SizedBox(width: 28, child: Text('${entry.rank}', style: AppTypography.monoMd)),
                          CircleAvatar(radius: 13, backgroundColor: isPromotionZone ? AppColors.teal : (isDemotionZone ? AppColors.danger.withOpacity(0.5) : AppColors.line)),
                          const SizedBox(width: AppSpacing.s3),
                          Expanded(child: Text(entry.name, style: entry.isCurrentUser ? AppTypography.bodyLgEmphasis : AppTypography.bodyMd)),
                          Text('${entry.weeklyXp} XP', style: AppTypography.monoMd),
                        ]),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppTabBar(
        currentIndex: 3,
        onTap: (index) => ref.read(currentTabIndexProvider.notifier).state = index,
      ),
    );
  }
}
