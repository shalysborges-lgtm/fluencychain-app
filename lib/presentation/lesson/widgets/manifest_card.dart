import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/lesson_content.dart';

/// Componente de assinatura #2 do Design System (Etapa 10, seção 3.4).
/// Usado no Resultado de lição, Resultado de missão e Certificado final.
class ManifestCard extends StatelessWidget {
  const ManifestCard({super.key, required this.result});

  final LessonResult result;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.s5),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s4),
        color: AppColors.ink,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(result.lessonCode, style: _mono),
                Text(result.moduleCode, style: _mono),
              ],
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              '+${result.xpEarned} XP',
              style: AppTypography.displayLg.copyWith(color: AppColors.amber, fontSize: 30),
            ),
            const SizedBox(height: AppSpacing.s4),
            CustomPaint(
              painter: _DashedLinePainter(),
              size: const Size(double.infinity, 1),
            ),
            const SizedBox(height: AppSpacing.s4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ACERTOS ${result.correctCount}/${result.totalCount}', style: _mono),
                Text('STREAK ${result.newStreakDays}D', style: _mono),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static const TextStyle _mono = TextStyle(
    fontFamily: 'IBMPlexMono',
    fontSize: 10,
    color: Color(0xFF9FA39A),
    letterSpacing: 0.6,
  );
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..strokeWidth = 1.5;
    const dashWidth = 5.0;
    const dashSpace = 4.0;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
