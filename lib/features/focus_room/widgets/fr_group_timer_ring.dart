import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Shared session ring: stronger presence, soft glow pulse, layered track.
class FrGroupTimerRing extends StatefulWidget {
  const FrGroupTimerRing({
    super.key,
    required this.progress,
    required this.centerLabel,
    required this.subLabel,
    this.sessionLengthLabel,
  });

  /// 0.0 = empty, 1.0 = full (time remaining fraction).
  final double progress;
  final String centerLabel;
  final String subLabel;

  /// Optional quiet line under the title (e.g. "25 min block").
  final String? sessionLengthLabel;

  @override
  State<FrGroupTimerRing> createState() => _FrGroupTimerRingState();
}

class _FrGroupTimerRingState extends State<FrGroupTimerRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glow;

  @override
  void initState() {
    super.initState();
    _glow = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = widget.progress.clamp(0.0, 1.0);
    const size = 296.0;

    return AnimatedBuilder(
      animation: _glow,
      builder: (context, _) {
        final pulse = 0.55 + 0.45 * Curves.easeInOut.transform(_glow.value);
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.12 * pulse),
                      blurRadius: 36 * pulse,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: AppColors.tertiary.withValues(alpha: 0.06 * pulse),
                      blurRadius: 48,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
              CustomPaint(
                size: Size(size, size),
                painter: _RingPainter(progress: p),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.96, end: 1).animate(anim),
                        child: child,
                      ),
                    ),
                    child: Text(
                      widget.centerLabel,
                      key: ValueKey(widget.centerLabel),
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w300,
                        letterSpacing: -0.5,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.subLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      letterSpacing: 2.2,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  if (widget.sessionLengthLabel != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.sessionLengthLabel!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceSubtle,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress});

  final double progress;

  static const _stroke = 11.0;
  static const _inset = 14.0;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final outerR = size.width / 2 - _inset;
    final innerFillR = outerR - _stroke - 10;

    final fill = Paint()
      ..color = AppColors.surfaceContainer
      ..style = PaintingStyle.fill;
    canvas.drawCircle(c, innerFillR, fill);

    final track = Paint()
      ..color = AppColors.surfaceContainerHighest
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round;

    final arcRect = Rect.fromCircle(center: c, radius: outerR - _stroke / 2);

    canvas.drawArc(arcRect, 0, 2 * math.pi, false, track);

    const start = -math.pi / 2;
    final sweep = 2 * math.pi * progress;

    if (sweep > 0.001) {
      final glowArc = Paint()
        ..color = AppColors.primary.withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _stroke + 10
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawArc(arcRect, start, sweep, false, glowArc);

      final arcGradient = SweepGradient(
        startAngle: start,
        endAngle: start + 2 * math.pi,
        tileMode: TileMode.clamp,
        colors: [
          AppColors.primaryDim,
          AppColors.primary,
          const Color(0xFFFFD54F),
          AppColors.primary,
          AppColors.primaryDim,
        ],
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        transform: GradientRotation(start),
      );

      final fg = Paint()
        ..shader = arcGradient.createShader(arcRect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(arcRect, start, sweep, false, fg);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
