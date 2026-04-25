import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Full-screen overlay that renders a soft radial glow following the cursor.
/// Pointer-transparent — all hit-tests pass through.
///
/// Updates cursor position via [ValueNotifier] + [CustomPaint.repaint] so the
/// widget tree is NOT rebuilt on hover. Rebuilding during a hover callback
/// mutates the mouse_tracker's subscriber list mid-update and triggers the
/// `!_debugDuringDeviceUpdate` assertion. Paint-only updates sidestep that.
class CursorSpotlight extends StatefulWidget {
  const CursorSpotlight({
    super.key,
    required this.child,
    this.radius = 360,
    this.color,
  });

  final Widget child;
  final double radius;
  final Color? color;

  @override
  State<CursorSpotlight> createState() => _CursorSpotlightState();
}

class _CursorSpotlightState extends State<CursorSpotlight> {
  final ValueNotifier<Offset?> _position = ValueNotifier<Offset?>(null);

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glow = (widget.color ?? AppColors.accent).withOpacity(0.14);

    return Stack(
      children: [
        // The app.
        widget.child,
        // Transparent mouse listener on top, hit-test-through.
        Positioned.fill(
          child: MouseRegion(
            opaque: false,
            hitTestBehavior: HitTestBehavior.translucent,
            onHover: (e) => _position.value = e.position,
            onExit: (_) => _position.value = null,
            child: IgnorePointer(
              child: CustomPaint(
                painter: _SpotlightPainter(
                  position: _position,
                  radius: widget.radius,
                  color: glow,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter({
    required this.position,
    required this.radius,
    required this.color,
  }) : super(repaint: position);

  final ValueNotifier<Offset?> position;
  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = position.value;
    if (center == null) return;
    final gradient = RadialGradient(
      colors: [color, color.withOpacity(0)],
    );
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..blendMode = BlendMode.plus;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter old) =>
      old.radius != radius || old.color != color;
}
