import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/responsive_utils.dart';

/// Card wrapper that tilts in 3D toward the cursor and paints a soft shine
/// that tracks the pointer.
///
/// Tilt tracks the cursor instantly via [Transform] — no animation lag.
/// An [AnimationController] drives a 0→1 strength value that scales the tilt,
/// lift, and shine on hover enter/exit so the effect eases in and out cleanly.
///
/// [ValueNotifier] is used for the cursor position so that notifying listeners
/// does NOT call [setState] on this widget directly — calling setState during
/// a MouseTracker device-update cycle triggers `!_debugDuringDeviceUpdate`.
class TiltCard extends StatefulWidget {
  const TiltCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.maxTilt = 0.06,
    this.lift = 6,
    this.showShine = true,
    this.borderRadius = 8,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double maxTilt; // radians
  final double lift; // pixels
  final bool showShine;
  final double borderRadius;

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> with SingleTickerProviderStateMixin {
  final GlobalKey _cardKey = GlobalKey();
  late final AnimationController _controller;
  late final Animation<double> _strength;
  final ValueNotifier<Offset> _cursor = ValueNotifier(Offset.zero);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _strength = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _cursor.dispose();
    super.dispose();
  }

  Size _cardSize() {
    final box = _cardKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return Size.zero;
    return box.size;
  }

  @override
  Widget build(BuildContext context) {
    final padding = widget.padding ?? const EdgeInsets.all(AppSpacing.xl);
    final radius = BorderRadius.circular(widget.borderRadius);

    if (!ResponsiveUtils.isDesktop(context)) {
      return GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border.withOpacity(0.3)),
            borderRadius: radius,
          ),
          child: widget.child,
        ),
      );
    }

    return MouseRegion(
      onEnter: (e) {
        _cursor.value = e.localPosition;
        _controller.forward();
      },
      onHover: (e) => _cursor.value = e.localPosition,
      onExit: (_) => _controller.reverse(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_strength, _cursor]),
          builder: (context, child) {
            final t = _strength.value;
            final local = _cursor.value;
            final size = _cardSize();
            final nx = size.width > 0 ? (local.dx / size.width) * 2 - 1 : 0.0;
            final ny = size.height > 0 ? (local.dy / size.height) * 2 - 1 : 0.0;

            final cardColor = Color.lerp(
              AppColors.surface.withOpacity(0.6),
              AppColors.surface,
              t,
            )!;
            final borderColor = Color.lerp(
              AppColors.border.withOpacity(0.3),
              AppColors.accent.withOpacity(0.5),
              t,
            )!;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0008)
                ..translate(0.0, -widget.lift * t)
                ..rotateX(-ny * widget.maxTilt * t)
                ..rotateY(nx * widget.maxTilt * t),
              child: Container(
                key: _cardKey,
                padding: padding,
                decoration: BoxDecoration(
                  color: cardColor,
                  border: Border.all(color: borderColor),
                  borderRadius: radius,
                  boxShadow: t > 0
                      ? [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.12 * t),
                            blurRadius: 40 * t,
                            spreadRadius: -4,
                            offset: Offset(0, 12 * t),
                          ),
                        ]
                      : const [],
                ),
                foregroundDecoration: _ShineDecoration(
                  center: local,
                  color: widget.showShine && t > 0
                      ? AppColors.accent.withOpacity(0.18 * t)
                      : const Color(0x00000000),
                  borderRadius: radius,
                ),
                child: child,
              ),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}

/// Foreground decoration that paints a radial shine spot at [center].
class _ShineDecoration extends Decoration {
  const _ShineDecoration({
    required this.center,
    required this.color,
    required this.borderRadius,
  });

  final Offset center;
  final Color color;
  final BorderRadius borderRadius;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _ShineBoxPainter(this);
  }
}

class _ShineBoxPainter extends BoxPainter {
  _ShineBoxPainter(this.deco);
  final _ShineDecoration deco;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final size = cfg.size;
    if (size == null || size.isEmpty) return;
    if (deco.color.alpha == 0) return;
    final rect = offset & size;
    final radius = size.longestSide * 0.8;
    final shader = RadialGradient(
      colors: [deco.color, deco.color.withOpacity(0)],
    ).createShader(Rect.fromCircle(
      center: offset + deco.center,
      radius: radius,
    ));

    canvas.save();
    canvas.clipRRect(deco.borderRadius.toRRect(rect));
    canvas.drawRect(
      rect,
      Paint()
        ..shader = shader
        ..blendMode = BlendMode.plus,
    );
    canvas.restore();
  }
}
