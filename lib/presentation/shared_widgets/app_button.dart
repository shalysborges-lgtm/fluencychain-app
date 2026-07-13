import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

enum AppButtonVariant { primary, amber, ghost }

/// Componente de botão do Design System (Etapa 10, seção 3.1).
/// Trata os 4 estados: default, pressed (via InkWell), disabled, loading.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    final Color background = switch (variant) {
      AppButtonVariant.primary => AppColors.ink,
      AppButtonVariant.amber => AppColors.amber,
      AppButtonVariant.ghost => Colors.transparent,
    };

    final Color foreground = switch (variant) {
      AppButtonVariant.primary => AppColors.paper,
      AppButtonVariant.amber => AppColors.ink,
      AppButtonVariant.ghost => AppColors.ink,
    };

    final Border? border =
        variant == AppButtonVariant.ghost ? Border.all(color: AppColors.line, width: 1.5) : null;

    return Opacity(
      opacity: isDisabled && !isLoading ? 0.4 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.s3),
        onTap: isDisabled ? null : onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
          decoration: BoxDecoration(
            color: background,
            border: border,
            borderRadius: BorderRadius.circular(AppSpacing.s3),
          ),
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
                )
              : Text(
                  label,
                  style: AppTypography.bodyLgEmphasis.copyWith(color: foreground),
                ),
        ),
      ),
    );
  }
}
