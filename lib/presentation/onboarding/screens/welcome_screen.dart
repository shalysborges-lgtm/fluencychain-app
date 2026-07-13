import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/user_profile.dart';
import '../../shared_widgets/app_button.dart';
import '../../shared_widgets/choice_card.dart';
import '../controllers/onboarding_controller.dart';
import 'diagnostic_test_screen.dart';
import 'professional_area_screen.dart';

/// Tela 1 do onboarding (Etapa 7, Fluxo 1). Bilíngue por padrão do sistema
/// (RF09.6) — aqui usando texto direto em PT para simplificar o exemplo;
/// em produção viria de app_pt.arb / app_en.arb via flutter_localizations.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

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
              Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.amber,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s2),
                  Text('FluencyChain', style: AppTypography.displaySm),
                ],
              ),
              const SizedBox(height: AppSpacing.s8),
              Text('Vamos calibrar\nsua trilha.', style: AppTypography.displayLg),
              const SizedBox(height: AppSpacing.s6),
              ChoiceCard(
                leadingEmoji: '🌱',
                title: 'Começar do zero',
                description: 'Sem experiência prévia com inglês corporativo',
                selected: state.startingMode == StartingMode.zero,
                onTap: () => controller.selectStartingMode(StartingMode.zero),
              ),
              const SizedBox(height: AppSpacing.s3),
              ChoiceCard(
                leadingEmoji: '📈',
                title: 'Já tenho uma base',
                description: 'Fazer um teste rápido de nivelamento (3-5 min)',
                selected: state.startingMode == StartingMode.hasBase,
                onTap: () => controller.selectStartingMode(StartingMode.hasBase),
              ),
              const Spacer(),
              AppButton(
                label: 'Continuar',
                onPressed: state.startingMode == null
                    ? null
                    : () {
                        final next = state.requiresDiagnosticTest
                            ? const DiagnosticTestScreen()
                            : const ProfessionalAreaScreen();
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => next),
                        );
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
