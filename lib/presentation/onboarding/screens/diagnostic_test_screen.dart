import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/repositories/onboarding_repository.dart';
import '../../shared_widgets/app_button.dart';
import '../../shared_widgets/choice_card.dart';
import '../controllers/onboarding_controller.dart';
import 'professional_area_screen.dart';

/// Teste de nivelamento adaptativo (Módulo 0 — Plano Mestre, seção 5).
/// Versão simplificada aqui: sequência fixa curta de perguntas de
/// múltipla escolha (listening + reading). A versão adaptativa completa
/// (ramificação por dificuldade) é responsabilidade do backend/srs module
/// e será refinada quando o banco de questões (Etapa 19) estiver pronto —
/// esta tela já está preparada para consumir qualquer lista de perguntas.
class DiagnosticTestScreen extends ConsumerStatefulWidget {
  const DiagnosticTestScreen({super.key});

  @override
  ConsumerState<DiagnosticTestScreen> createState() => _DiagnosticTestScreenState();
}

class _DiagnosticTestScreenState extends ConsumerState<DiagnosticTestScreen> {
  final List<_DiagnosticQuestion> _questions = const [
    _DiagnosticQuestion(
      id: 'diag_01',
      prompt: '"Could you send me the ___ for this shipment?"',
      options: ['invoice', 'invoicing', 'invoiced'],
      correctIndex: 0,
    ),
    _DiagnosticQuestion(
      id: 'diag_02',
      prompt: '"Our supplier ___ the order two days late."',
      options: ['deliver', 'delivered', 'delivering'],
      correctIndex: 1,
    ),
    _DiagnosticQuestion(
      id: 'diag_03',
      prompt: '"We need to review the dashboard ___ tomorrow\'s meeting."',
      options: ['before', 'since', 'during'],
      correctIndex: 0,
    ),
  ];

  int _currentIndex = 0;
  int? _selectedOption;
  final List<DiagnosticAnswer> _answers = [];

  void _selectOption(int index) => setState(() => _selectedOption = index);

  Future<void> _next() async {
    final question = _questions[_currentIndex];
    _answers.add(DiagnosticAnswer(
      questionId: question.id,
      answer: question.options[_selectedOption!],
    ));

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
      });
      return;
    }

    final controller = ref.read(onboardingControllerProvider.notifier);
    await controller.submitDiagnosticTest(_answers);

    if (!mounted) return;
    final state = ref.read(onboardingControllerProvider);
    if (state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage!)),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfessionalAreaScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

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
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.ink),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: AppColors.line,
                        color: AppColors.amber,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s6),
              Text('Teste rápido de nivelamento', style: AppTypography.displayMd),
              const SizedBox(height: AppSpacing.s2),
              Text(
                'Sem pressa — isso ajusta sua trilha, não é uma prova.',
                style: AppTypography.bodySm,
              ),
              const SizedBox(height: AppSpacing.s6),
              Text(question.prompt, style: AppTypography.displaySm),
              const SizedBox(height: AppSpacing.s4),
              ...List.generate(question.options.length, (i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.s2),
                  child: ChoiceCard(
                    title: question.options[i],
                    description: '',
                    selected: _selectedOption == i,
                    onTap: () => _selectOption(i),
                  ),
                );
              }),
              const Spacer(),
              AppButton(
                label: _currentIndex == _questions.length - 1 ? 'Finalizar teste' : 'Próxima',
                isLoading: state.isSubmitting,
                onPressed: _selectedOption == null ? null : _next,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiagnosticQuestion {
  const _DiagnosticQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });

  final String id;
  final String prompt;
  final List<String> options;
  final int correctIndex;
}
