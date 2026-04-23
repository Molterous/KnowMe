import 'package:flutter/material.dart';

class HoverWidget extends StatefulWidget {
  const HoverWidget({
    super.key,
    required this.builder,
    this.onTap,
  });

  final Widget Function(BuildContext context, bool isHovered) builder;
  final VoidCallback? onTap;

  @override
  State<HoverWidget> createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<HoverWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: widget.builder(context, _isHovered),
      ),
    );
  }
}
