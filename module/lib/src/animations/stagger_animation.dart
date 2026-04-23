import 'package:flutter/material.dart';
import 'fade_slide_transition.dart';

class StaggerAnimation extends StatelessWidget {
  const StaggerAnimation({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 80),
    this.initialDelay = Duration.zero,
    this.itemOffset = const Offset(0, 20),
  });

  final List<Widget> children;
  final Duration staggerDelay;
  final Duration initialDelay;
  final Offset itemOffset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(children.length, (i) {
        return FadeSlideTransition(
          delay: initialDelay + (staggerDelay * i),
          offset: itemOffset,
          child: children[i],
        );
      }),
    );
  }
}
