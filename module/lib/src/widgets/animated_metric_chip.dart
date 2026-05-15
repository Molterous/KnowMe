import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import '../utils/responsive_utils.dart';

/// Same visual as [MetricChip] but if [label] starts with a number (e.g.
/// "40% boost", "3x faster", "12k users"), the numeric portion counts up
/// from 0 when the chip first becomes visible.
class AnimatedMetricChip extends StatefulWidget {
  const AnimatedMetricChip({super.key, required this.label});

  final String label;

  @override
  State<AnimatedMetricChip> createState() => _AnimatedMetricChipState();
}

class _AnimatedMetricChipState extends State<AnimatedMetricChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _anim;
  late final _Parsed _parsed;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    _parsed = _Parsed.from(widget.label);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);

    final chip = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentDim,
        border: Border.all(color: AppColors.accent.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: isDesktop
          ? AnimatedBuilder(
              animation: _anim,
              builder: (_, __) {
                if (!_parsed.hasNumber) {
                  return Text(widget.label, style: AppTextStyles.accent);
                }
                final current = (_parsed.number * _anim.value);
                final display = _parsed.isInt
                    ? current.round().toString()
                    : current.toStringAsFixed(1);
                return Text(
                  '${_parsed.prefix}$display${_parsed.suffix}',
                  style: AppTextStyles.accent,
                );
              },
            )
          : Text(widget.label, style: AppTextStyles.accent),
    );

    if (!_parsed.hasNumber || !isDesktop) return chip;

    return VisibilityDetector(
      key: ValueKey('metric_${widget.label}_$hashCode'),
      onVisibilityChanged: (info) {
        if (!_triggered && info.visibleFraction > 0.3) {
          _triggered = true;
          _controller.forward();
        }
      },
      child: chip,
    );
  }
}

class _Parsed {
  _Parsed({
    required this.hasNumber,
    required this.prefix,
    required this.number,
    required this.suffix,
    required this.isInt,
  });

  final bool hasNumber;
  final String prefix;
  final double number;
  final String suffix;
  final bool isInt;

  /// Matches an optional leading non-digit prefix, a number (int or decimal),
  /// and a trailing suffix. Examples:
  ///   "40% boost" → prefix="" number=40 suffix="% boost" isInt=true
  ///   "3x faster" → prefix="" number=3 suffix="x faster" isInt=true
  ///   "~$1.5M"    → prefix="~$" number=1.5 suffix="M" isInt=false
  static final _re = RegExp(r'^(\D*?)(\d+(?:\.\d+)?)(.*)$');

  factory _Parsed.from(String label) {
    final m = _re.firstMatch(label);
    if (m == null) {
      return _Parsed(
        hasNumber: false,
        prefix: '',
        number: 0,
        suffix: label,
        isInt: true,
      );
    }
    final raw = m.group(2)!;
    final n = double.tryParse(raw) ?? 0;
    return _Parsed(
      hasNumber: true,
      prefix: m.group(1) ?? '',
      number: n,
      suffix: m.group(3) ?? '',
      isInt: !raw.contains('.'),
    );
  }
}
