import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/curriculum.dart';

/// Implementa a navegação não-linear identificada na Etapa 5 (persona
/// Lucas) e formalizada na Etapa 6 (Arquitetura da Informação, seção 4).
/// Módulos técnicos são sugestão, não bloqueio — exceto o Módulo 7
/// (isFinalExam), que é desabilitado aqui e tratado por regra de negócio
/// no backend (Etapa 11, seção 9).
class JumpToModuleModal extends StatelessWidget {
  const JumpToModuleModal({
    super.key,
    required this.modules,
    required this.onModuleSelected,
  });

  final List<LearningModule> modules;
  final ValueChanged<LearningModule> onModuleSelected;

  static Future<void> show(
    BuildContext context, {
    required List<LearningModule> modules,
    required ValueChanged<LearningModule> onModuleSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.s5)),
      ),
      builder: (_) => JumpToModuleModal(modules: modules, onModuleSelected: onModuleSelected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pular para um módulo', style: AppTypography.displayMd),
            const SizedBox(height: AppSpacing.s2),
            Text(
              'Recomendamos seguir a ordem, mas você pode escolher.',
              style: AppTypography.bodySm,
            ),
            const SizedBox(height: AppSpacing.s4),
            ...modules.map((module) {
              final bool disabled = module.isFinalExam;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s2),
                child: Opacity(
                  opacity: disabled ? 0.4 : 1,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSpacing.s3),
                    onTap: disabled
                        ? null
                        : () {
                            Navigator.of(context).pop();
                            onModuleSelected(module);
                          },
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.s3),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.line, width: 1.5),
                        borderRadius: BorderRadius.circular(AppSpacing.s3),
                      ),
                      child: Row(
                        children: [
                          Text(module.code, style: AppTypography.monoMd),
                          const SizedBox(width: AppSpacing.s3),
                          Expanded(child: Text(module.titlePt, style: AppTypography.bodyMd)),
                          if (disabled)
                            const Icon(Icons.lock_outline, size: 16, color: AppColors.muted),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
