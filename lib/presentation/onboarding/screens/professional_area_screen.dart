import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/user_profile.dart';
import '../../shared_widgets/app_button.dart';
import '../../shared_widgets/choice_card.dart';
import '../controllers/onboarding_controller.dart';
import 'daily_goal_screen.dart';

/// RF02.4 — multi-select de área profissional. Alimenta a priorização
/// de trilha na Home (Etapa 6) e o `target_professional_areas` das
/// missões/módulos (Etapa 11).
class ProfessionalAreaScreen extends ConsumerWidget {
  const ProfessionalAreaScreen({super.key});

  static const _areas = [
    (ProfessionalArea.logistics, '📦', 'Logística / Armazém'),
    (ProfessionalArea.transport, '🚚', 'Transportes / Fretes'),
    (ProfessionalArea.supplyChain, '🔗', 'Supply Chain'),
    (ProfessionalArea.bi, '📊', 'Dados / BI'),
    (ProfessionalArea.general, '🌐', 'Geral / Não sei ainda'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Qual sua área?', style: AppTypography.displayMd),
              const SizedBox(height: AppSpacing.s2),
              Text('Isso personaliza sua trilha. Pode escolher mais de uma.',
                  style: AppTypography.bodySm),
              const SizedBox(height: AppSpacing.s5),
              Expanded(
                child: ListView.separated(
                  itemCount: _areas.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s2),
                  itemBuilder: (context, i) {
                    final (area, emoji, label) = _areas[i];
                    return ChoiceCard(
                      leadingEmoji: emoji,
                      title: label,
                      description: '',
                      selected: state.professionalAreas.contains(area),
                      onTap: () => controller.toggleProfessionalArea(area),
                    );
                  },
                ),
              ),
              AppButton(
                label: 'Continuar',
                onPressed: state.professionalAreas.isEmpty
                    ? null
                    : () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const DailyGoalScreen()),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
