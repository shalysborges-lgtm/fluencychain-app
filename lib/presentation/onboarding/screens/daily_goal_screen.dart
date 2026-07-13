import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../main.dart' show MainTabShell;
import '../../shared_widgets/app_button.dart';
import '../../shared_widgets/choice_card.dart';
import '../controllers/onboarding_controller.dart';

/// Combina RF02.5 (urgência/objetivo) e a definição de meta diária,
/// conforme Etapa 7 (Fluxo 1). Duas sub-etapas dentro da mesma tela
/// para não alongar demais o onboarding (meta: <5min até a Home).
class DailyGoalScreen extends ConsumerStatefulWidget {
  const DailyGoalScreen({super.key});

  @override
  ConsumerState<DailyGoalScreen> createState() => _DailyGoalScreenState();
}

class _DailyGoalScreenState extends ConsumerState<DailyGoalScreen> {
  bool _showingGoalStep = false;

  static const _urgencyOptions = [
    (UrgencyGoal.careerGrowth, '🚀', 'Crescer na carreira', 'Sem prazo específico, quero evoluir'),
    (UrgencyGoal.upcomingCall, '📞', 'Tenho uma call em breve', 'Preciso praticar fala rápido'),
    (UrgencyGoal.upcomingInterview, '🎯', 'Tenho uma entrevista em breve', 'Preciso de foco intensivo'),
    (UrgencyGoal.justLearning, '🌿', 'Só quero aprender', 'No meu próprio ritmo'),
  ];

  static const _goalOptions = [5, 10, 15, 20];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s5),
          child: _showingGoalStep
              ? _buildGoalStep(context, state, controller)
              : _buildUrgencyStep(context, state, controller),
        ),
      ),
    );
  }

  Widget _buildUrgencyStep(
    BuildContext context,
    OnboardingState state,
    OnboardingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('O que te trouxe aqui?', style: AppTypography.displayMd),
        const SizedBox(height: AppSpacing.s2),
        Text('Vamos priorizar o conteúdo certo para o seu momento.',
            style: AppTypography.bodySm),
        const SizedBox(height: AppSpacing.s5),
        Expanded(
          child: ListView.separated(
            itemCount: _urgencyOptions.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s2),
            itemBuilder: (context, i) {
              final (goal, emoji, title, desc) = _urgencyOptions[i];
              return ChoiceCard(
                leadingEmoji: emoji,
                title: title,
                description: desc,
                selected: state.urgencyGoal == goal,
                onTap: () => controller.selectUrgencyGoal(goal),
              );
            },
          ),
        ),
        AppButton(
          label: 'Continuar',
          onPressed: state.urgencyGoal == null
              ? null
              : () => setState(() => _showingGoalStep = true),
        ),
      ],
    );
  }

  Widget _buildGoalStep(
    BuildContext context,
    OnboardingState state,
    OnboardingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: () => setState(() => _showingGoalStep = false),
        ),
        Text('Quanto tempo por dia?', style: AppTypography.displayMd),
        const SizedBox(height: AppSpacing.s2),
        Text(
          state.isSprintMode
              ? 'Detectamos urgência — sugerimos um ritmo mais intenso.'
              : '15-20 minutos já bastam para manter o ritmo.',
          style: AppTypography.bodySm,
        ),
        const SizedBox(height: AppSpacing.s5),
        Wrap(
          spacing: AppSpacing.s2,
          runSpacing: AppSpacing.s2,
          children: _goalOptions.map((minutes) {
            final selected = state.dailyGoalMinutes == minutes;
            return GestureDetector(
              onTap: () => controller.selectDailyGoal(minutes),
              child: Container(
                width: 66,
                height: 66,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.ink : Colors.transparent,
                  border: Border.all(color: selected ? AppColors.ink : AppColors.line, width: 1.5),
                  borderRadius: BorderRadius.circular(AppSpacing.s3),
                ),
                child: Text(
                  '$minutes min',
                  style: AppTypography.bodyMd.copyWith(
                    color: selected ? AppColors.paper : AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (state.errorMessage != null) ...[
          const SizedBox(height: AppSpacing.s4),
          Text(state.errorMessage!, style: AppTypography.bodySm.copyWith(color: AppColors.danger)),
        ],
        const Spacer(),
        AppButton(
          label: 'Começar minha primeira lição',
          isLoading: state.isSubmitting,
          onPressed: state.dailyGoalMinutes == null
              ? null
              : () async {
                  // TODO: userId real vem do Supabase Auth (Etapa 12) após login.
                  final success = await controller.completeOnboarding('current-user-id');
                  if (success && context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MainTabShell()),
                      (route) => false,
                    );
                  }
                },
        ),
      ],
    );
  }
}
