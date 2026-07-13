import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/curriculum.dart';

/// Card de missão ativa (RF05.8), fixo no topo da rota na Home.
class MissionCard extends StatelessWidget {
  const MissionCard({super.key, required this.mission, required this.onTap});

  final ActiveMission mission;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.s3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: AppSpacing.s3),
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(AppSpacing.s3),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MISSÃO',
                    style: AppTypography.monoSm.copyWith(color: AppColors.amber),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    mission.titlePt,
                    style: AppTypography.bodyLgEmphasis.copyWith(color: AppColors.paper),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              '${mission.currentStep}/${mission.totalSteps}',
              style: AppTypography.monoMd.copyWith(color: AppColors.paper),
            ),
          ],
        ),
      ),
    );
  }
}
