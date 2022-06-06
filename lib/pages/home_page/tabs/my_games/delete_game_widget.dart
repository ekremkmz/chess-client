import '../../../../data/local/db_manager.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:lottie/lottie.dart';

class DeleteGameWidget extends StatefulWidget {
  const DeleteGameWidget({
    Key? key,
    required this.id,
    required this.animation,
  }) : super(key: key);

  final Animation<double> animation;
  final int id;

  @override
  State<DeleteGameWidget> createState() => _DeleteGameWidgetState();
}

class _DeleteGameWidgetState extends State<DeleteGameWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: const Offset(0, 0),
          ).animate(widget.animation),
          child: const Text(
            "Delete",
            style: TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Ink(
          decoration: const ShapeDecoration(
            shape: CircleBorder(),
          ),
          child: IconButton(
            padding: const EdgeInsets.all(0),
            icon: AnimatedBuilder(
              animation: widget.animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: (1 - widget.animation.value) * math.pi / 2,
                  child: child,
                );
              },
              child: Lottie.asset(
                "assets/lottie/delete_lottie.json",
                controller: _controller,
              ),
            ),
            onPressed: () {
              final isDeleted = DBManager.instance.deleteGame(widget.id);
              if (isDeleted) {
                _controller.forward().whenComplete(Navigator.of(context).pop);
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
