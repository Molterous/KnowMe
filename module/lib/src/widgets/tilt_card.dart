import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Card wrapper that tilts in 3D toward the cursor and paints a soft shine
/// that tracks the pointer. Uses a [ValueNotifier] + [AnimatedBuilder] for
/// hover state so onHover does NOT call setState — mutating widgets during
/// a mouse tracker update triggers `!_debugDuringDeviceUpdate`. All
/// MouseRegions and foreground decorations stay statically mounted.
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

class _HoverState {
  const _HoverState({required this.hovered, this.local});
  final bool hovered;
  final Offset? local;

  static const idle = _HoverState(hovered: false);
}

class _TiltCardState extends State<TiltCard> {
  final GlobalKey _cardKey = GlobalKey();
  final ValueNotifier<_HoverState> _hover =
      ValueNotifier<_HoverState>(_HoverState.idle);

  @override
  void dispose() {
    _hover.dispose();
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

    return MouseRegion(
      onEnter: (e) =>
          _hover.value = _HoverState(hovered: true, local: e.localPosition),
      onHover: (e) =>
          _hover.value = _HoverState(hovered: true, local: e.localPosition),
      onExit: (_) => _hover.value = _HoverState.idle,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _hover,
          builder: (context, _) {
            final s = _hover.value;
            final size = _cardSize();
            final nx = (s.local != null && size.width > 0)
                ? (s.local!.dx / size.width) * 2 - 1
                : 0.0;
            final ny = (s.local != null && size.height > 0)
                ? (s.local!.dy / size.height) * 2 - 1
                : 0.0;
            final rotateY = s.hovered ? nx * widget.maxTilt : 0.0;
            final rotateX = s.hovered ? -ny * widget.maxTilt : 0.0;
            final translateY = s.hovered ? -widget.lift : 0.0;

            return AnimatedContainer(
              key: _cardKey,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0008)
                ..translate(0.0, translateY)
                ..rotateX(rotateX)
                ..rotateY(rotateY),
              transformAlignment: Alignment.center,
              padding: padding,
              decoration: BoxDecoration(
                color: s.hovered
                    ? AppColors.surface
                    : AppColors.surface.withOpacity(0.6),
                border: Border.all(
                  color: s.hovered
                      ? AppColors.accent.withOpacity(0.5)
                      : AppColors.border.withOpacity(0.3),
                ),
                borderRadius: radius,
                boxShadow: s.hovered
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.12),
                          blurRadius: 40,
                          spreadRadius: -4,
                          offset: const Offset(0, 12),
                        ),
                      ]
                    : const [],
              ),
              // Always provide foregroundDecoration so Container's internal
              // widget tree stays structurally stable across hover toggles.
              // Toggling this between null and non-null re-wraps the child in
              // a DecoratedBox, which remounts stateful descendants and would
              // restart their one-shot animations (e.g. AnimatedMetricChip).
              foregroundDecoration: _ShineDecoration(
                center: s.local ?? Offset.zero,
                color: widget.showShine && s.hovered && s.local != null
                    ? AppColors.accent.withOpacity(0.18)
                    : const Color(0x00000000),
                borderRadius: radius,
              ),
              child: widget.child,
            );
          },
        ),
      ),
    );
  }
}

/// A [Decoration] painted via [AnimatedContainer.foregroundDecoration]
/// — renders over the child but never participates in layout or hit testing.
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
