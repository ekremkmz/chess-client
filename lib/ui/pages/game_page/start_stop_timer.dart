import 'dart:async';

class StartStopTimer implements _StartStopTimerInterface {
  StartStopTimer({
    required this.presetTime,
    this.mode = StartStopTimerMode.countDown,
    Duration refreshDuration = const Duration(milliseconds: 16),
  }) {
    assert(presetTime >= 0, "'presetTime' must be a possitive number");
    _refreshDuration = refreshDuration;
    _controller.add(presetTime);
  }

  late int presetTime;
  late Duration _refreshDuration;
  StartStopTimerMode mode;
  int? _startTime;
  bool _active = false;

  final _controller = StreamController<int>.broadcast();
  late final _stream = _controller.stream;

  Timer? _timer;

  @override
  Stream<int> get millisecondStream => _stream;

  @override
  Stream<int> get secondStream =>
      millisecondStream.map((event) => event ~/ 1000);

  @override
  Stream<int> get minuteStream =>
      millisecondStream.map((event) => event ~/ 60000);

  @override
  int get millisecond => presetTime;

  @override
  int get second => presetTime ~/ 1000;

  @override
  int get minute => presetTime ~/ 60000;

  @override
  void setTimer(int time, {StartStopTimerMode? mode}) {
    assert(time >= 0, "'time' must be a possitive number");
    presetTime = time;
    if (mode != null) {
      this.mode = mode;
    }
    _controller.add(presetTime);
  }

  @override
  void start() {
    _active = true;
    _startTime = DateTime.now().millisecondsSinceEpoch;
    _timer = Timer.periodic(_refreshDuration, _timerHandler);
  }

  @override
  void stop() {
    _active = false;
    _timer?.cancel();
  }

  void _timerHandler(Timer timer) {
    if (!_active) return;
    int currentTime = _newCurrentTime();
    if (currentTime <= 0) {
      currentTime = 0;
      stop();
    }
    _controller.add(currentTime);
  }

  int _newCurrentTime() {
    switch (mode) {
      case StartStopTimerMode.countDown:
        return presetTime - _timeDiff;

      case StartStopTimerMode.countUp:
        return presetTime + _timeDiff;
    }
  }

  int get _timeDiff => DateTime.now().millisecondsSinceEpoch - _startTime!;

  void dispose() {
    stop();
    _controller.close();
  }
}

abstract class _StartStopTimerInterface {
  Stream<int> get millisecondStream;
  Stream<int> get secondStream;
  Stream<int> get minuteStream;
  int get millisecond;
  int get second;
  int get minute;

  void setTimer(int time, {required StartStopTimerMode mode});
  void start();
  void stop();
}

enum StartStopTimerMode {
  countDown,
  countUp,
}
