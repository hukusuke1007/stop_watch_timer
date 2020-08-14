import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class StopWatchRecord {
  StopWatchRecord({
    this.rawValue,
    this.hours,
    this.minute,
    this.second,
    this.displayTime,
  });
  int rawValue;
  int hours;
  int minute;
  int second;
  String displayTime;
}

/// StopWatch ExecuteType
enum StopWatchExecute { start, stop, reset, lap }

/// StopWatchTimer
class StopWatchTimer {
  StopWatchTimer({
    this.isLapHours = true,
    this.onChange,
    this.onChangeRawSecond,
    this.onChangeRawMinute,
  }) {
    _configure();
  }

  final bool isLapHours;
  final Function(int) onChange;
  final Function(int) onChangeRawSecond;
  final Function(int) onChangeRawMinute;

  final PublishSubject<int> _elapsedTime = PublishSubject<int>();

  final BehaviorSubject<int> _rawTimeController =
      BehaviorSubject<int>.seeded(0);
  ValueStream<int> get rawTime => _rawTimeController;

  final BehaviorSubject<int> _secondTimeController =
      BehaviorSubject<int>.seeded(0);
  ValueStream<int> get secondTime => _secondTimeController;

  final BehaviorSubject<int> _minuteTimeController =
      BehaviorSubject<int>.seeded(0);
  ValueStream<int> get minuteTime => _minuteTimeController;

  final BehaviorSubject<List<StopWatchRecord>> _recordsController =
      BehaviorSubject<List<StopWatchRecord>>.seeded([]);
  ValueStream<List<StopWatchRecord>> get records => _recordsController;

  final PublishSubject<StopWatchExecute> _executeController =
      PublishSubject<StopWatchExecute>();
  Stream<StopWatchExecute> get execute => _executeController;
  Sink<StopWatchExecute> get onExecute => _executeController.sink;

  Timer _timer;
  int _startTime = 0;
  int _stopTime = 0;
  int _presetTime = 0;
  int _second;
  int _minute;
  List<StopWatchRecord> _records = [];

  /// Get display time.
  static String getDisplayTime(
    int value, {
    bool hours = true,
    bool minute = true,
    bool second = true,
    bool milliSecond = true,
    String hoursRightBreak = ':',
    String minuteRightBreak = ':',
    String secondRightBreak = '.',
  }) {
    final hoursStr = getDisplayTimeHours(value);
    final mStr = getDisplayTimeMinute(value, hours: hours);
    final sStr = getDisplayTimeSecond(value);
    final msStr = getDisplayTimeMilliSecond(value);
    var result = '';
    if (hours) {
      result += '$hoursStr';
    }
    if (minute) {
      if (hours) {
        result += hoursRightBreak;
      }
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

  /// Get display hours time.
  static String getDisplayTimeHours(int mSec) {
    return getRawHours(mSec).floor().toString().padLeft(2, '0');
  }

  /// Get display minute time.
  static String getDisplayTimeMinute(int mSec, {bool hours = false}) {
    if (hours) {
      return getMinute(mSec).floor().toString().padLeft(2, '0');
    } else {
      return getRawMinute(mSec).floor().toString().padLeft(2, '0');
    }
  }

  /// Get display second time.
  static String getDisplayTimeSecond(int mSec) {
    final s = (mSec % 60000 / 1000).floor();
    return s.toString().padLeft(2, '0');
  }

  /// Get display millisecond time.
  static String getDisplayTimeMilliSecond(int mSec) {
    final ms = (mSec % 1000 / 10).floor();
    return ms.toString().padLeft(2, '0');
  }

  /// Get Raw Hours.
  static int getRawHours(int value) => (value / (3600 * 1000)).floor();

  /// Get Raw Minute. 0 ~ 59. 1 hours = 0.
  static int getMinute(int value) => (value / (60 * 1000) % 60).floor();

  /// Get Raw Minute
  static int getRawMinute(int value) => (value / 60000).floor();

  /// Get Raw Second
  static int getRawSecond(int value) => (value / 1000).floor();

  /// When finish running timer, it need to dispose.
  Future<void> dispose() async {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
    await _elapsedTime.close();
    await _rawTimeController.close();
    await _secondTimeController.close();
    await _minuteTimeController.close();
    await _recordsController.close();
    await _executeController.close();
  }

  /// Get display millisecond time.
  // ignore: avoid_bool_literals_in_conditional_expressions
  bool get isRunning => _timer != null ? _timer.isActive : false;

  void setPresetHoursTime(int value) =>
      setPresetTime(mSec: value * 3600 * 1000);

  void setPresetMinuteTime(int value) => setPresetTime(mSec: value * 60 * 1000);

  void setPresetSecondTime(int value) => setPresetTime(mSec: value * 1000);

  /// Set preset time. 1000 mSec => 1 sec
  void setPresetTime({@required int mSec}) {
    if (_timer == null) {
      _presetTime = mSec;
      _elapsedTime.add(_presetTime);
    }
  }

  Future _configure() async {
    _elapsedTime.listen((value) {
      _rawTimeController.add(value);
      if (onChange != null) {
        onChange(value);
      }
      final latestSecond = getRawSecond(value);
      if (_second != latestSecond) {
        _secondTimeController.add(latestSecond);
        _second = latestSecond;
        if (onChangeRawSecond != null) {
          onChangeRawSecond(latestSecond);
        }
      }
      final latestMinute = getRawMinute(value);
      if (_minute != latestMinute) {
        _minuteTimeController.add(latestMinute);
        _minute = latestMinute;
        if (onChangeRawMinute != null) {
          onChangeRawMinute(latestMinute);
        }
      }
    });

    _executeController.where((value) => value != null).listen((value) {
      switch (value) {
        case StopWatchExecute.start:
          _start();
          break;
        case StopWatchExecute.stop:
          _stop();
          break;
        case StopWatchExecute.reset:
          _reset();
          break;
        case StopWatchExecute.lap:
          _lap();
          break;
      }
    });
  }

  void _handle(Timer timer) =>
      _elapsedTime.add(DateTime.now().millisecondsSinceEpoch -
          _startTime +
          _stopTime +
          _presetTime);

  void _start() {
    if (_timer == null || !_timer.isActive) {
      _startTime = DateTime.now().millisecondsSinceEpoch;
      _timer = Timer.periodic(const Duration(milliseconds: 1), _handle);
    }
  }

  void _stop() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      _timer = null;
      _stopTime += DateTime.now().millisecondsSinceEpoch - _startTime;
    }
  }

  void _reset() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
      _timer = null;
    }
    _startTime = 0;
    _stopTime = 0;
    _second = null;
    _minute = null;
    _records = [];
    _recordsController.add(_records);
    _elapsedTime.add(_presetTime);
  }

  void _lap() {
    if (_timer != null && _timer.isActive) {
      final rawValue = _rawTimeController.value;
      _records.add(StopWatchRecord(
        rawValue: rawValue,
        hours: getRawHours(rawValue),
        minute: getRawMinute(rawValue),
        second: getRawSecond(rawValue),
        displayTime: getDisplayTime(rawValue, hours: isLapHours),
      ));
      _recordsController.add(_records);
    }
  }
}
