import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:test/test.dart';

void main() {
  // Max int that can be represented in any platform, including the web, without
  // losing precision.
  const maxInt = 9007199254740992; // 2 ^ 53
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
    group('Static methods', () {
      group('Method: getRawHours', () {
        const msKey = 'msKey';
        const expectedHoursKey = 'expectedHoursKey';
        const oneHourInMilliseconds = 1000 * 60 * 60;
        const threeHoursInMilliseconds = 3 * 1000 * 60 * 60;
        const maxHoursInMilliseconds = maxInt;
        const maxHours =
            2501999792; // 9007199254740992 ~/ oneHourInMilliseconds

        final testCases = <Map<String, int>>[
          {msKey: 0, expectedHoursKey: 0},
          {msKey: 1, expectedHoursKey: 0},
          {msKey: 1234, expectedHoursKey: 0},
          {msKey: oneHourInMilliseconds - 1, expectedHoursKey: 0},
          {msKey: oneHourInMilliseconds, expectedHoursKey: 1},
          {msKey: oneHourInMilliseconds + 1, expectedHoursKey: 1},
          {msKey: threeHoursInMilliseconds - 1, expectedHoursKey: 2},
          {msKey: threeHoursInMilliseconds, expectedHoursKey: 3},
          {msKey: threeHoursInMilliseconds + 1, expectedHoursKey: 3},
          {msKey: maxHoursInMilliseconds - 1, expectedHoursKey: maxHours},
          {msKey: maxHoursInMilliseconds, expectedHoursKey: maxHours},
        ];
        for (final item in testCases) {
          final milliSecond = item[msKey]!;
          final expectedRawHours = item[expectedHoursKey]!;
          test(
            'Should return $expectedRawHours h for input $milliSecond ms',
            () => expect(
              StopWatchTimer.getRawHours(milliSecond),
              equals(expectedRawHours),
            ),
          );
        }
      });
    });
  });
}
