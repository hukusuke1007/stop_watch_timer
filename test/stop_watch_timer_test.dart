import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:test/test.dart';

void main() {
  group('Class: StopWatchTimer', () {
    group('Constructor: unnamed', () {
      test('Should have default values', () {
        final stopWatchTimerWithDefaults = StopWatchTimer();
        expect(stopWatchTimerWithDefaults.isLapHours, isTrue);
        expect(stopWatchTimerWithDefaults.mode, equals(StopWatchMode.countUp));
        expect(stopWatchTimerWithDefaults.refreshTime, equals(1));
        expect(stopWatchTimerWithDefaults.onChange, isNull);
        expect(stopWatchTimerWithDefaults.onChangeRawSecond, isNull);
        expect(stopWatchTimerWithDefaults.onChangeRawMinute, isNull);
        expect(stopWatchTimerWithDefaults.onStopped, isNull);
        expect(stopWatchTimerWithDefaults.onEnded, isNull);
        expect(stopWatchTimerWithDefaults.initialPresetTime, 0);
      });
      test('Should have non-default values', () {
        const isLapHours = false;
        const mode = StopWatchMode.countDown;
        const refreshTime = 3;
        void onChange(int i) {}
        void onChangeRawSecond(int i) {}
        void onChangeRawMinute(int i) {}
        void onStopped() {}
        void onEnded() {}
        const presetMillisecond = 102;
        final stopWatchTimerWithDefaults = StopWatchTimer(
          isLapHours: isLapHours,
          mode: mode,
          refreshTime: refreshTime,
          onChange: onChange,
          onChangeRawSecond: onChangeRawSecond,
          onChangeRawMinute: onChangeRawMinute,
          onStopped: onStopped,
          onEnded: onEnded,
          presetMillisecond: presetMillisecond,
        );

        expect(stopWatchTimerWithDefaults.isLapHours, isLapHours);
        expect(stopWatchTimerWithDefaults.mode, equals(mode));
        expect(stopWatchTimerWithDefaults.refreshTime, equals(refreshTime));
        expect(stopWatchTimerWithDefaults.onChange, onChange);
        expect(stopWatchTimerWithDefaults.onChangeRawSecond, onChangeRawSecond);
        expect(stopWatchTimerWithDefaults.onChangeRawMinute, onChangeRawMinute);
        expect(stopWatchTimerWithDefaults.onStopped, onStopped);
        expect(stopWatchTimerWithDefaults.onEnded, onEnded);
        expect(stopWatchTimerWithDefaults.initialPresetTime, presetMillisecond);
      });
    });
  });
}
