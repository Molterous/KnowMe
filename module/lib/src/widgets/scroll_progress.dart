import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Thin accent bar that fills 0→100% as the attached [controller] scrolls
/// from top to bottom. Renders invisibly (0 width) when content does not
/// overflow the viewport.
class ScrollProgressBar extends StatefulWidget {
  const ScrollProgressBar({
    super.key,
    required this.controller,
    this.height = 2,
    this.color,
  });

  final ScrollController controller;
  final double height;
  final Color? color;

  @override
  State<ScrollProgressBar> createState() => _ScrollProgressBarState();
}

class _ScrollProgressBarState extends State<ScrollProgressBar> {
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_update);
  }

  @override
  void didUpdateWidget(ScrollProgressBar old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(_update);
      widget.controller.addListener(_update);
    }
  }

  void _update() {
    if (!widget.controller.hasClients) return;
    final max = widget.controller.position.maxScrollExtent;
    final offset = widget.controller.offset;
    final p = max <= 0 ? 0.0 : (offset / max).clamp(0.0, 1.0);
    if ((p - _progress).abs() > 0.001) {
      setState(() => _progress = p);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, c) {
          return Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: AppColors.divider.withOpacity(0.4),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 80),
                curve: Curves.linear,
                width: c.maxWidth * _progress,
                height: widget.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (widget.color ?? AppColors.accent).withOpacity(0.6),
                      widget.color ?? AppColors.accent,
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
