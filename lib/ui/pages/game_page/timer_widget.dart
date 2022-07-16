import 'dart:math';

import 'package:flutter/material.dart';

import 'start_stop_timer.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({
    required this.lastPlayed,
    required this.time,
    required this.active,
    Key? key,
  }) : super(key: key);

  final int? lastPlayed;
  final int time;
  final bool active;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late StartStopTimer _timer;

  @override
  void initState() {
    super.initState();

    int delta = 0;

    if (widget.lastPlayed != null && widget.active) {
      delta = deltaFromLastMove;
    }

    _timer = StartStopTimer(
      presetTime: max(widget.time - delta, 0),
      mode: StartStopTimerMode.countDown,
    );

    if (widget.active) {
      _timer.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<int>(
              initialData: _timer.minute,
              stream: _timer.minuteStream,
              builder: (context, snapshot) {
                final val = snapshot.data;

                if (val == null) return const SizedBox();

                var valstr = val.toString();
                if (val < 10) {
                  valstr = "0$valstr";
                }

                return Text(
                  valstr,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                );
              },
            ),
            const Text(
              " : ",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            StreamBuilder<int>(
              initialData: _timer.second,
              stream: _timer.secondStream,
              builder: (context, snapshot) {
                var val = snapshot.data;

                if (val == null) return const SizedBox();

                val %= 60;

                var valstr = val.toString();
                if (val < 10) {
                  valstr = "0$valstr";
                }

                return Text(
                  valstr,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                );
              },
            ),
            const Text(
              " : ",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            StreamBuilder<int>(
              initialData: _timer.millisecond,
              stream: _timer.millisecondStream,
              builder: (context, snapshot) {
                var val = snapshot.data;

                if (val == null) return const SizedBox();

                val %= 1000;

                var valstr = val.toString();
                if (val < 10) {
                  valstr = "0$valstr";
                }

                valstr = valstr.substring(0, 2);
                return Text(
                  valstr,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant TimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // There is no move yet
    if (widget.lastPlayed == null) return;

    final stopping = oldWidget.active && !widget.active;
    final starting = !oldWidget.active && widget.active;

    if (stopping) {
      _timer.stop();
      _timer.setTimer(widget.time);
    }

    if (starting) {
      _timer.setTimer(widget.time);
      _timer.start();
    }
  }

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }

  int get deltaFromLastMove =>
      DateTime.now().toUtc().millisecondsSinceEpoch - widget.lastPlayed!;
}
