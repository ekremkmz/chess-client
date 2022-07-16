import 'package:flutter/material.dart';

class NotifyBackgroundWidget extends StatefulWidget {
  const NotifyBackgroundWidget({
    Key? key,
    required this.duration,
  }) : super(key: key);

  final Duration duration;

  @override
  State<NotifyBackgroundWidget> createState() => _NotifyBackgroundWidgetState();
}

class _NotifyBackgroundWidgetState extends State<NotifyBackgroundWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.addStatusListener(_statusListener);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // return AnimatedBuilder(
    //   animation: _controller.view,
    //   builder: (context, _) {
    //     final value = (255 - 128 * _controller.value).toInt();
    //     final backgroundColor = Color.fromARGB(255, 255, value, value);
    //     return Container(color: backgroundColor);
    //   },
    // );
    return RepaintBoundary(
      child: CustomPaint(
        isComplex: true,
        painter: _NotifyBackgroundPainter(
          animation: _controller.view,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_statusListener);
    _controller.dispose();
    super.dispose();
  }

  void _statusListener(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.dismissed:
        _controller.forward();
        break;
      case AnimationStatus.completed:
        _controller.reverse();
        break;
      default:
    }
  }
}

class _NotifyBackgroundPainter extends CustomPainter {
  _NotifyBackgroundPainter({
    required this.animation,
  }) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final value = (255 - 128 * animation.value).toInt();
    final backgroundColor = Color.fromARGB(255, 255, value, value);
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
