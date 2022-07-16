import 'package:flutter/material.dart';

import 'start_stop_timer.dart';

class CountDownWidget extends StatefulWidget {
  const CountDownWidget({
    Key? key,
    this.from,
    required this.duration,
  }) : super(key: key);

  final Duration? from;
  final Duration duration;

  @override
  State<CountDownWidget> createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  late StartStopTimer _timer;

  @override
  void initState() {
    super.initState();
    int preset = widget.duration.inMilliseconds;

    if (widget.from != null) {
      final from = widget.from!.inMilliseconds;
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      preset = preset - (now - from);
    }
    _timer = StartStopTimer(
      mode: StartStopTimerMode.countDown,
      presetTime: preset,
    );
    _timer.start();
  }

  @override
  Widget build(BuildContext context) {
    const message = TextSpan(text: "Waiting for the first move... ");
    return StreamBuilder<int>(
      stream: _timer.secondStream,
      builder: (context, snapshot) {
        return Text.rich(
          TextSpan(
            children: [
              message,
              if (snapshot.hasData)
                TextSpan(
                  text: snapshot.data.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant CountDownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.from != oldWidget.from) {
      int preset = widget.duration.inMilliseconds;
      if (widget.from != null) {
        final from = widget.from!.inMilliseconds;
        final now = DateTime.now().toUtc().millisecondsSinceEpoch;
        preset = preset - (now - from);
      }
      _timer.setTimer(preset);
    }
  }
}
