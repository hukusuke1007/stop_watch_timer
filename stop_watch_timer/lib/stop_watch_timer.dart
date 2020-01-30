import 'dart:async';

class StopWatchTimer {
  StopWatchTimer() {
    _configure();
  }

  final StreamController<int> _elapsedTime = StreamController<int>();

  final StreamController<int> _rawTimeController = StreamController<int>();
  Stream<int> get rawTime => _rawTimeController.stream;

  final StreamController<int> _secondTimeController = StreamController<int>();
  Stream<int> get secondTime => _secondTimeController.stream;

  final StreamController<int> _minuteTimeController = StreamController<int>();
  Stream<int> get minuteTime => _minuteTimeController.stream;

  Timer _timer;
  int _startTime = 0;
  int _stopTime = 0;
  int _second;
  int _minute;

  Future dispose() async {
    await _elapsedTime.close();
    await _rawTimeController.close();
    await _secondTimeController.close();
    await _minuteTimeController.close();
  }

  void start() {
    _startTime = DateTime.now().millisecondsSinceEpoch;
    _timer = Timer.periodic(const Duration(milliseconds: 1), _handle);
  }

  void stop() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      _timer = null;
      _stopTime += DateTime.now().millisecondsSinceEpoch - _startTime;
    }
  }

  void reset() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      _timer = null;
    }
    _startTime = 0;
    _stopTime = 0;
    _second = null;
    _minute = null;
    _elapsedTime.add(0);
  }

  String getDisplayTime(int value, {
    bool minute = true,
    bool second = true,
    bool milliSecond = true,
    String minuteRightBreak = ':',
    String secondRightBreak = '.',
  }) {
    final m = (value / 60000).floor();
    final s = (value % 60000 / 1000).floor();
    final ms = (value % 1000 / 10).floor();
    final mStr = m.toString().padLeft(2, '0');
    final sStr = s.toString().padLeft(2, '0');
    final msStr = ms.toString().padLeft(2, '0');
    var result = '';
    if (minute) {
      result += '$mStr';
    }
    if (second) {
      if (minute) {
        result += minuteRightBreak;
      }
      result += '$sStr';
    }
    if (milliSecond) {
      if (second) {
        result += secondRightBreak;
      }
      result += '$msStr';
    }
    return result;
  }

  Future _configure() async {
    _elapsedTime.add(0);
    _elapsedTime.stream.listen((value) {
      _rawTimeController.add(value);
      final latestSecond = _getSecond(value);
      if (_second != latestSecond) {
        _secondTimeController.add(latestSecond);
        _second = latestSecond;
      }
      final latestMinute = _getMinute(value);
      if (_minute != latestMinute) {
        _minuteTimeController.add(latestMinute);
        _minute = latestMinute;
      }
    });
  }

  int _getMinute(int value) => (value / 60000).floor();
  int _getSecond(int value) => (value / 1000).floor();
  void _handle(Timer timer) => _elapsedTime.add(DateTime.now().millisecondsSinceEpoch - _startTime + _stopTime);

}