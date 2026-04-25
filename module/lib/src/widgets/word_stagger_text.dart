import 'package:flutter/material.dart';

/// Splits [text] on whitespace and reveals each word with a stagger.
/// Each word fades + slides up independently.
class WordStaggerText extends StatefulWidget {
  const WordStaggerText({
    super.key,
    required this.text,
    this.style,
    this.stagger = const Duration(milliseconds: 90),
    this.duration = const Duration(milliseconds: 520),
    this.initialDelay = Duration.zero,
    this.offset = const Offset(0, 24),
  });

  final String text;
  final TextStyle? style;
  final Duration stagger;
  final Duration duration;
  final Duration initialDelay;
  final Offset offset;

  @override
  State<WordStaggerText> createState() => _WordStaggerTextState();
}

class _WordStaggerTextState extends State<WordStaggerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final words = widget.text.split(' ');
    final total = widget.duration + widget.stagger * words.length;
    _controller = AnimationController(vsync: this, duration: total);
    Future.delayed(widget.initialDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.text.split(' ');
    final totalMs = _controller.duration!.inMilliseconds;
    final wordMs = widget.duration.inMilliseconds;
    final stepMs = widget.stagger.inMilliseconds;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Wrap(
          spacing: 0,
          children: [
            for (var i = 0; i < words.length; i++) ...[
              _buildWord(words[i], i, totalMs, wordMs, stepMs),
              if (i < words.length - 1) SizedBox(width: _spaceWidth()),
            ],
          ],
        );
      },
    );
  }

  double _spaceWidth() {
    final fontSize = widget.style?.fontSize ?? 16;
    return fontSize * 0.28;
  }

  Widget _buildWord(
      String word, int i, int totalMs, int wordMs, int stepMs) {
    final startMs = i * stepMs;
    final endMs = (startMs + wordMs).clamp(0, totalMs);
    final start = startMs / totalMs;
    final end = endMs / totalMs;
    final anim = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end == start ? (start + 0.001).clamp(0, 1) : end,
          curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) {
        final t = anim.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(
              widget.offset.dx * (1 - t),
              widget.offset.dy * (1 - t),
            ),
            child: Text(word, style: widget.style),
          ),
        );
      },
    );
  }
}
