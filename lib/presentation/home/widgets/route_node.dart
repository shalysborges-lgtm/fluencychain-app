import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/curriculum.dart';

/// Nó da trilha em mapa de rota (Etapa 10, seção 3.3 — componente de
/// assinatura #1). Três estados fixos: locked, done, active.
/// `alignLeft` alterna o zigue-zague do caminho (ver HomeScreen).
class RouteNode extends StatelessWidget {
  const RouteNode({
    super.key,
    required this.node,
    required this.onTap,
    this.alignLeft = false,
  });

  final LessonRouteNode node;
  final VoidCallback? onTap;
  final bool alignLeft;

  @override
  Widget build(BuildContext context) {
    final bool isActive = node.status == LessonNodeStatus.active;
    final bool isDone = node.status == LessonNodeStatus.done;
    final bool isLocked = node.status == LessonNodeStatus.locked;

    final Color background = isDone
        ? AppColors.teal
        : isActive
            ? AppColors.amber
            : const Color(0xFFEAE9E4);

    final Color foreground = isDone
        ? Colors.white
        : isActive
            ? AppColors.ink
            : AppColors.muted;

    final double size = isActive ? 66 : 58;

    return Align(
      alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(
          left: alignLeft ? 40 : 0,
          right: alignLeft ? 0 : 40,
        ),
        child: Semantics(
          button: !isLocked,
          label: '${node.lesson.titlePt}, ${_statusLabel(node.status)}',
          child: GestureDetector(
            onTap: isLocked ? null : onTap,
            child: Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.paper, width: 2),
                boxShadow: isActive
                    ? const [BoxShadow(color: AppColors.amberDeep, offset: Offset(0, 4))]
                    : const [BoxShadow(color: AppColors.line, offset: Offset(0, 2))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isDone ? Icons.check : (isLocked ? Icons.lock_outline : Icons.play_arrow),
                    color: foreground,
                    size: 18,
                  ),
                  Text(
                    node.lesson.code.replaceAll('LESSON-', 'L'),
                    style: AppTypography.monoSm.copyWith(color: foreground, fontSize: 9),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _statusLabel(LessonNodeStatus status) => switch (status) {
        LessonNodeStatus.locked => 'bloqueado',
        LessonNodeStatus.active => 'disponível agora',
        LessonNodeStatus.done => 'concluído',
      };
}

/// Trilha pontilhada que conecta os nós verticalmente — reforça a
/// metáfora de "mapa de rota" (Plano Mestre + Design System).
class RouteDivider extends StatelessWidget {
  const RouteDivider({super.key, this.height = 26});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        child: const VerticalDivider(color: AppColors.line, thickness: 2, width: 2),
      ),
    );
  }
}
