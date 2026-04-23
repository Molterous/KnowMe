import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Animates a numeric prefix (e.g. "40" in "40% boost") counting up from 0.
class CounterText extends StatefulWidget {
  const CounterText({
    super.key,
    required this.value,
    required this.suffix,
    this.style,
    this.duration = const Duration(milliseconds: 1200),
  });

  final int value;
  final String suffix;
  final TextStyle? style;
  final Duration duration;

  @override
  State<CounterText> createState() => _CounterTextState();
}

class _CounterTextState extends State<CounterText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0, end: widget.value.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey('counter_${widget.value}_${widget.suffix}'),
      onVisibilityChanged: (info) {
        if (!_triggered && info.visibleFraction > 0.3) {
          _triggered = true;
          _controller.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (_, __) => Text(
          '${_animation.value.round()}${widget.suffix}',
          style: widget.style ??
              AppTextStyles.headlineLarge.copyWith(color: AppColors.accent),
        ),
      ),
    );
  }
}
