import 'package:flutter/material.dart';

/// Wraps a child that translates toward the cursor while hovered, within
/// [pull] pixels. Smooth return to origin on exit.
///
/// Uses [ValueNotifier] + [AnimatedBuilder] so onHover does NOT call
/// setState — that would rebuild the widget subtree during the mouse
/// tracker's update phase and trip `!_debugDuringDeviceUpdate`.
class MagneticHover extends StatefulWidget {
  const MagneticHover({
    super.key,
    required this.child,
    this.pull = 10,
    this.scaleOnHover = 1.03,
  });

  final Widget child;
  final double pull;
  final double scaleOnHover;

  @override
  State<MagneticHover> createState() => _MagneticHoverState();
}

class _MagneticState {
  const _MagneticState({required this.hovered, required this.offset});
  final bool hovered;
  final Offset offset;

  static const idle = _MagneticState(hovered: false, offset: Offset.zero);
}

class _MagneticHoverState extends State<MagneticHover> {
  final GlobalKey _childKey = GlobalKey();
  final ValueNotifier<_MagneticState> _state =
      ValueNotifier<_MagneticState>(_MagneticState.idle);

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  void _onHover(Offset local) {
    final box = _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final size = box.size;
    if (size.width == 0 || size.height == 0) return;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final dx = (local.dx - cx) / cx;
    final dy = (local.dy - cy) / cy;
    _state.value = _MagneticState(
      hovered: true,
      offset: Offset(dx * widget.pull, dy * widget.pull),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => _onHover(e.localPosition),
      onHover: (e) => _onHover(e.localPosition),
      onExit: (_) => _state.value = _MagneticState.idle,
      child: AnimatedBuilder(
        animation: _state,
        builder: (context, child) {
          final s = _state.value;
          return AnimatedContainer(
            key: _childKey,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..translate(s.offset.dx, s.offset.dy)
              ..scale(s.hovered ? widget.scaleOnHover : 1.0),
            transformAlignment: Alignment.center,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
