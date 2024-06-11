import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:test/test.dart';

void main() {
  // Constants used in the tests:
  // Max int that can be represented in any platform, including the web, without
  // losing precision.
  const maxInt = 9007199254740992; // 2 ^ 53
  const oneHourInMilliseconds = 1000 * 60 * 60;
  const maxHoursInMilliseconds = maxInt;
  const maxHours = 2501999792; // 9007199254740992 ~/ oneHourInMilliseconds
  const maxHoursStr = '2501999792';

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
        const threeHoursInMilliseconds = 3 * oneHourInMilliseconds;

        final testCases = <Map<String, int>>[
          {'milliSecond': 0, 'expected': 0},
          {'milliSecond': 1, 'expected': 0},
          {'milliSecond': 1234, 'expected': 0},
          {'milliSecond': oneHourInMilliseconds - 1, 'expected': 0},
          {'milliSecond': oneHourInMilliseconds, 'expected': 1},
          {'milliSecond': oneHourInMilliseconds + 1, 'expected': 1},
          {'milliSecond': threeHoursInMilliseconds - 1, 'expected': 2},
          {'milliSecond': threeHoursInMilliseconds, 'expected': 3},
          {'milliSecond': threeHoursInMilliseconds + 1, 'expected': 3},
          {'milliSecond': maxHoursInMilliseconds - 1, 'expected': maxHours},
          {'milliSecond': maxHoursInMilliseconds, 'expected': maxHours},
        ];
        for (final item in testCases) {
          final milliSecond = item['milliSecond']!;
          final expectedRawHours = item['expected']!;
          test(
            'Should return $expectedRawHours h for input $milliSecond ms',
            () => expect(
              StopWatchTimer.getRawHours(milliSecond),
              equals(expectedRawHours),
            ),
          );
        }
      });

      group('Method: getDisplayTimeHours', () {
        const fifteenHoursInMilliseconds = 15 * oneHourInMilliseconds;
        final testCases = <Map<String, dynamic>>[
          {'mSec': 0, 'expected': '00'},
          {'mSec': 1, 'expected': '00'},
          {'mSec': 1234, 'expected': '00'},
          {'mSec': oneHourInMilliseconds - 1, 'expected': '00'},
          {'mSec': oneHourInMilliseconds, 'expected': '01'},
          {'mSec': oneHourInMilliseconds + 1, 'expected': '01'},
          {'mSec': fifteenHoursInMilliseconds - 1, 'expected': '14'},
          {'mSec': fifteenHoursInMilliseconds, 'expected': '15'},
          {'mSec': fifteenHoursInMilliseconds + 1, 'expected': '15'},
          {'mSec': maxHoursInMilliseconds - 1, 'expected': maxHoursStr},
          {'mSec': maxHoursInMilliseconds, 'expected': maxHoursStr},
        ];
        for (final item in testCases) {
          final mSec = item['mSec']! as int;
          final expectedHourDisplayTime = item['expected']! as String;
          test(
            'Should return $expectedHourDisplayTime representation for input $mSec ms',
            () => expect(
              StopWatchTimer.getDisplayTimeHours(mSec),
              equals(expectedHourDisplayTime),
            ),
          );
        }
      });
    });
  });
}
