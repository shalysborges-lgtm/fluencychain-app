import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/tab_navigation_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/ai_tutor.dart';
import '../../shared_widgets/app_tab_bar.dart';
import '../controllers/chat_controller.dart';

/// Etapa 6, seção 3.4 — home do Tutor IA: chat livre no topo, cards de
/// simulação abaixo. O histórico de mensagens some ao trocar de aba
/// (chat é "practice", não precisa persistir na Home da aba — a sessão
/// completa fica salva no backend via ai_simulation_sessions, Etapa 11).
class TutorHomeScreen extends ConsumerStatefulWidget {
  const TutorHomeScreen({super.key});

  @override
  ConsumerState<TutorHomeScreen> createState() => _TutorHomeScreenState();
}

class _TutorHomeScreenState extends ConsumerState<TutorHomeScreen> {
  final _textController = TextEditingController();

  static const _simulations = [
    SimulationOption(type: SimulationType.interview, titlePt: 'Simulação de Entrevista', scenarioCode: 'GENERIC_INTERVIEW'),
    SimulationOption(type: SimulationType.meeting, titlePt: 'Simulação de Reunião (S&OP)', scenarioCode: 'SOP_MEETING'),
    SimulationOption(type: SimulationType.presentation, titlePt: 'Simulação de Apresentação', scenarioCode: 'DASHBOARD_PRESENTATION'),
  ];

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatControllerProvider);
    final chatController = ref.read(chatControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Tutor IA', style: AppTypography.displayMd),
              const SizedBox(height: AppSpacing.s4),
              Expanded(
                child: chatState.messages.isEmpty
                    ? _SimulationList(simulations: _simulations, onTap: (sim) {
                        // Abre SimulationScreen (fora do escopo deste
                        // sub-bloco) passando sim.scenarioCode.
                      })
                    : ListView.builder(
                        itemCount: chatState.messages.length,
                        itemBuilder: (context, i) {
                          final m = chatState.messages[i];
                          final isBot = m.role == ChatRole.assistant;
                          return Align(
                            alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: AppSpacing.s2),
                              padding: const EdgeInsets.all(AppSpacing.s3),
                              constraints: const BoxConstraints(maxWidth: 260),
                              decoration: BoxDecoration(
                                color: isBot ? AppColors.paperCard : AppColors.ink,
                                border: isBot ? Border.all(color: AppColors.line) : null,
                                borderRadius: BorderRadius.circular(AppSpacing.s3),
                              ),
                              child: Text(
                                m.text,
                                style: AppTypography.bodyMd.copyWith(color: isBot ? AppColors.ink : AppColors.paper),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (chatState.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s2),
                  child: Text(chatState.errorMessage!, style: AppTypography.bodySm.copyWith(color: AppColors.danger)),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Converse ou tire uma dúvida...',
                        contentPadding: const EdgeInsets.all(AppSpacing.s3),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.s3)),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s2),
                  IconButton(
                    icon: chatState.isSending
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.send, color: AppColors.ink),
                    onPressed: chatState.isSending
                        ? null
                        : () {
                            final text = _textController.text.trim();
                            if (text.isEmpty) return;
                            _textController.clear();
                            chatController.sendMessage(text);
                          },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppTabBar(
        currentIndex: 2,
        onTap: (index) => ref.read(currentTabIndexProvider.notifier).state = index,
      ),
    );
  }
}

class _SimulationList extends StatelessWidget {
  const _SimulationList({required this.simulations, required this.onTap});
  final List<SimulationOption> simulations;
  final ValueChanged<SimulationOption> onTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text('SIMULAÇÕES', style: AppTypography.monoSm.copyWith(color: AppColors.muted)),
        const SizedBox(height: AppSpacing.s2),
        ...simulations.map((sim) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s2),
              child: InkWell(
                onTap: () => onTap(sim),
                borderRadius: BorderRadius.circular(AppSpacing.s3),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.s4),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(AppSpacing.s3)),
                  child: Row(children: [
                    const Icon(Icons.mic_none, color: AppColors.teal),
                    const SizedBox(width: AppSpacing.s3),
                    Expanded(child: Text(sim.titlePt, style: AppTypography.bodyLgEmphasis)),
                    const Icon(Icons.chevron_right, color: AppColors.muted),
                  ]),
                ),
              ),
            )),
      ],
    );
  }
}
