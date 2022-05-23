import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({required this.time, Key? key}) : super(key: key);

  final int time;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void didUpdateWidget(covariant TimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.time != widget.time) {
      //TODO: update timer
    }
  }
}
