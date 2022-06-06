import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

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
  StopWatchTimer? _timer;
  late int _timeleft;

  @override
  void initState() {
    super.initState();

    int delta = 0;

    if (widget.lastPlayed != null) {
      delta = deltaFromLastMove;
    }

    _timeleft = widget.time;

    _timer = StopWatchTimer(
      presetMillisecond: _timeleft - delta,
      mode: StopWatchMode.countDown,
      onStop: () {
        _timer?.setPresetTime(mSec: _timeleft - deltaFromLastMove, add: false);
      },
    );

    if (widget.active) {
      _timer!.onExecute.add(StopWatchExecute.start);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<int>(
              stream: _timer!.minuteTime,
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
              stream: _timer!.secondTime,
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
              stream: _timer!.rawTime,
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
      _timeleft = widget.time - deltaFromLastMove;
      _timer?.onExecute.add(StopWatchExecute.stop);
    }

    if (starting) {
      _timeleft = widget.time - deltaFromLastMove;
      _timer?.setPresetTime(mSec: _timeleft, add: false);
      _timer?.onExecute.add(StopWatchExecute.start);
    }
  }

  @override
  void dispose() {
    _timer?.dispose();
    super.dispose();
  }

  int get deltaFromLastMove =>
      DateTime.now().millisecondsSinceEpoch - widget.lastPlayed!;
}
