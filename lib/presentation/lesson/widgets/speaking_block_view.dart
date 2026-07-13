import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/lesson_content.dart';

/// Bloco de speaking (Etapa 7, Fluxo 2 · Etapa 9, tela 04). A gravação em
/// si (permissão de microfone, captura de áudio) é responsabilidade de um
/// serviço de plataforma (ex: pacote `record`), injetado via callback
/// `onRecordingComplete` — mantém este widget livre de I/O de plataforma,
/// coerente com a separação domain/presentation da Etapa 13.
class SpeakingBlockView extends StatefulWidget {
  const SpeakingBlockView({
    super.key,
    required this.content,
    required this.isSubmitting,
    required this.feedback,
    required this.onRecordingComplete,
    required this.onContinue,
  });

  final SpeakingContent content;
  final bool isSubmitting;
  final PronunciationFeedback? feedback;
  final void Function(List<int> audioBytes) onRecordingComplete;
  final VoidCallback onContinue;

  @override
  State<SpeakingBlockView> createState() => _SpeakingBlockViewState();
}

class _SpeakingBlockViewState extends State<SpeakingBlockView> {
  bool _isRecording = false;

  void _toggleRecording() {
    setState(() => _isRecording = !_isRecording);
    if (!_isRecording) {
      // Em produção: para a captura e retorna os bytes reais do áudio.
      widget.onRecordingComplete(const []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('REPITA EM VOZ ALTA', style: AppTypography.monoSm.copyWith(color: AppColors.amberDeep)),
        const SizedBox(height: AppSpacing.s3),
        Text(
          '"${widget.content.targetSentence}"',
          style: AppTypography.displaySm,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.s6),
        if (widget.isSubmitting)
          const CircularProgressIndicator(color: AppColors.amber)
        else
          GestureDetector(
            onTap: _toggleRecording,
            child: Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: AppColors.amber,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.amber.withOpacity(0.25),
                    blurRadius: 0,
                    spreadRadius: _isRecording ? 10 : 8,
                  ),
                ],
              ),
              child: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: AppColors.ink,
                size: 28,
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.s5),
        if (widget.feedback != null) ...[
          Wrap(
            spacing: AppSpacing.s2,
            alignment: WrapAlignment.center,
            children: widget.feedback!.words.map((entry) {
              final color = switch (entry.value) {
                PhonemeScore.good => AppColors.teal,
                PhonemeScore.warning => AppColors.amberDeep,
                PhonemeScore.bad => AppColors.danger,
              };
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2, vertical: 4),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
                child: Text(
                  entry.key,
                  style: AppTypography.monoSm.copyWith(color: Colors.white),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.s4),
          TextButton(onPressed: widget.onContinue, child: const Text('Continuar')),
        ],
      ],
    );
  }
}
