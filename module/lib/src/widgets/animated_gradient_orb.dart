import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A slow-moving, blurred radial blob of accent color. Used as a background
/// "breathing" element behind key hero content.
class AnimatedGradientOrb extends StatefulWidget {
  const AnimatedGradientOrb({
    super.key,
    this.color,
    this.size = 240,
    this.duration = const Duration(seconds: 8),
    this.opacity = 0.22,
  });

  final Color? color;
  final double size;
  final Duration duration;
  final double opacity;

  @override
  State<AnimatedGradientOrb> createState() => _AnimatedGradientOrbState();
}

class _AnimatedGradientOrbState extends State<AnimatedGradientOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.accent;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = _controller.value * 2 * math.pi;
        final dx = math.cos(t) * 20;
        final dy = math.sin(t * 1.3) * 16;
        final scale = 1 + math.sin(t) * 0.06;
        return Transform.translate(
          offset: Offset(dx, dy),
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withOpacity(widget.opacity),
                    color.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
