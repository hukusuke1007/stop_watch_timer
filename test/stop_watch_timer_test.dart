import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:test/test.dart';
// ignore_for_file: lines_longer_than_80_chars

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
      test('Should have default values', () async {
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
        await stopWatchTimerWithDefaults.dispose();
      });
      test('Should have non-default values', () async {
        const isLapHours = false;
        const mode = StopWatchMode.countDown;
        const refreshTime = 3;
        void onChange(int i) {}
        void onChangeRawSecond(int i) {}
        void onChangeRawMinute(int i) {}
        void onStopped() {}
        void onEnded() {}
        const presetMillisecond = 102;
        final stopWatchTimer = StopWatchTimer(
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

        expect(stopWatchTimer.isLapHours, isLapHours);
        expect(stopWatchTimer.mode, equals(mode));
        expect(stopWatchTimer.refreshTime, equals(refreshTime));
        expect(stopWatchTimer.onChange, onChange);
        expect(stopWatchTimer.onChangeRawSecond, onChangeRawSecond);
        expect(stopWatchTimer.onChangeRawMinute, onChangeRawMinute);
        expect(stopWatchTimer.onStopped, onStopped);
        expect(stopWatchTimer.onEnded, onEnded);
        expect(stopWatchTimer.initialPresetTime, presetMillisecond);
        await stopWatchTimer.dispose();
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

      group('Method: getDisplayTime ', () {
        const time1 = 110484987;
        final testCases = <Map<String, dynamic>>[
          // input: [value, hours, minute, second, milliSecond, hoursRightBreak, minuteRightBreak, secondRightBreak]
          // value = 0
          {
            // 0
            'input': [0, true, false, false, true, ':', ':', '.'],
            'expectedOutput': '00:00',
          },
          {
            // 1
            'input': [0, false, true, true, false, ':', '', ''],
            'expectedOutput': '0000',
          },
          {
            // 2
            'input': [0, true, false, true, true, '', 'min ', 's '],
            'expectedOutput': '0000s 00',
          },
          {
            // 3
            'input': [0, true, true, false, false, 'h ', ':', '.'],
            'expectedOutput': '00h 00',
          },
          {
            // 4
            'input': [0, false, false, true, true, ':', ':', ''],
            'expectedOutput': '0000',
          },
          {
            // 5
            'input': [0, true, true, false, true, '', '', 's '],
            'expectedOutput': '000000',
          },
          {
            // 6
            'input': [0, false, true, true, false, 'h ', 'min ', '.'],
            'expectedOutput': '00min 00',
          },
          // value = 10
          {
            // 7
            'input': [10, true, false, true, false, '', 'min ', '.'],
            'expectedOutput': '0000',
          },
          {
            // 8
            'input': [10, false, false, false, true, '', 'min ', '.'],
            'expectedOutput': '01',
          },
          {
            // 9
            'input': [10, true, true, true, true, 'h ', ':', ''],
            'expectedOutput': '00h 00:0001',
          },
          {
            // 10
            'input': [10, true, false, false, false, ':', '', 's '],
            'expectedOutput': '00',
          },
          {
            // 11
            'input': [10, false, true, true, true, ':', 'min ', '.'],
            'expectedOutput': '00min 00.01',
          },
          {
            // 12
            'input': [10, true, true, false, false, '', ':', ''],
            'expectedOutput': '0000',
          },
          {
            // 13
            'input': [10, false, false, true, true, 'h ', ':', 's '],
            'expectedOutput': '00s 01',
          },
          {
            // 14
            'input': [10, true, true, true, false, ':', '', '.'],
            'expectedOutput': '00:0000',
          },
          // time1 = 110484987 which is equivalent to 30h 41min 24s 987ms
          {
            // 15
            'input': [time1, false, false, true, true, '', ':', ''],
            'expectedOutput': '2498',
          },
          {
            // 16
            'input': [time1, true, true, false, false, 'h ', ':', 's '],
            'expectedOutput': '30h 41',
          },
          {
            // 17
            'input': [time1, true, false, false, false, ':', 'min ', ''],
            'expectedOutput': '30',
          },
          {
            // 18
            'input': [time1, false, false, false, true, 'h ', '', '.'],
            'expectedOutput': '98',
          },
          {
            // 19
            'input': [time1, true, false, true, false, 'h ', '', '.'],
            'expectedOutput': '30h 24',
          },
          {
            // 20
            'input': [time1, true, true, false, true, ':', 'min ', ''],
            'expectedOutput': '30:41min 98',
          },
          // TODO(ArturAssisComp): this behavior is not clear by looking only
          // in the documentation. One must check the code to see the behavior.
          // Open an issue to improve the documentation.
          // ## Caveats
          // - If hours == false and minute == true, the minutes are represented
          // as raw minutes instead of 60 base. For example, 71 minutes would be
          // represented as 71 min itself instead of 11 min.
          {
            // 21
            'input': [time1, false, true, true, false, '', ':', 's '],
            'expectedOutput': '1841:24',
          },
          {
            // 22
            'input': [time1, true, false, true, true, 'h ', '', '.'],
            'expectedOutput': '30h 24.98',
          },
          {
            // 23
            'input': [time1, false, true, false, true, ':', 'min ', ''],
            'expectedOutput': '1841min 98',
          },
          {
            // 24
            'input': [time1, true, false, true, false, ':', ':', 's '],
            'expectedOutput': '30:24s ',
          },
          {
            // 25
            'input': [time1, false, true, false, true, '', ':', '.'],
            'expectedOutput': '1841:98',
          },
          // value = max which is equivalent to 2501999792h 59min 00s 992ms
          {
            // 26
            'input': [maxInt, true, true, false, true, 'h ', 'min ', ''],
            'expectedOutput': '${maxHoursStr}h 59min 99',
          },
          {
            // 27
            'input': [maxInt, true, true, false, false, '', ':', '.'],
            'expectedOutput': '${maxHoursStr}59:',
          },
          {
            // 28
            'input': [maxInt, true, false, true, true, 'h ', '', ''],
            'expectedOutput': '${maxHoursStr}h 0099',
          },
          {
            // 29
            'input': [maxInt, false, true, true, false, ':', 'min ', 's '],
            'expectedOutput': '150119987579min 00',
          },
          // TODO(ArturAssisComp): the parameters RightBreak can only be used as break
          // elements. If the user wants to use them as suffix, it is not necessarily
          // possible. For example, if I want "HH hours" or something like that, it is
          // not possible, it only returns "HH" even if hoursRightBreak is set to
          // " hours". Maybe adding new parameters: hourSuffix, minuteSuffix,
          // secondSuffix, and milliSecondSuffix and making them behave as lasting even
          // if the next time element is not displayed would make it clearer and more
          // flexible. Those who want to use them as right breaks, could do that, and
          // those who want to use them as suffixes could do too.
          {
            // 30
            'input': [time1, true, false, false, false, 'hours', '', ''],
            'expectedOutput': '30hours',
          },
        ];
        for (var i = 0; i < testCases.length; i++) {
          final item = testCases[i];
          final input = item['input']! as List<dynamic>;
          final value = input[0] as int;
          final hours = input[1] as bool;
          final minute = input[2] as bool;
          final second = input[3] as bool;
          final milliSecond = input[4] as bool;
          final hoursRightBreak = input[5] as String;
          final minuteRightBreak = input[6] as String;
          final secondRightBreak = input[7] as String;

          final expectedDisplayTime = item['expectedOutput']! as String;
          test(
            '($i) Should return $expectedDisplayTime representation for input $input',
            () => expect(
              StopWatchTimer.getDisplayTime(
                value,
                hours: hours,
                minute: minute,
                second: second,
                milliSecond: milliSecond,
                hoursRightBreak: hoursRightBreak,
                minuteRightBreak: minuteRightBreak,
                secondRightBreak: secondRightBreak,
              ),
              equals(expectedDisplayTime),
            ),
          );
        }
      });
    });

    group('Getters', () {
      group('Getter: isRunning', () {
        late StopWatchTimer countUp;
        late StopWatchTimer countDown100ms;
        late StopWatchTimer countDown10000ms;
        setUp(() {
          countUp = StopWatchTimer();
          countDown100ms = StopWatchTimer(
            mode: StopWatchMode.countDown,
            presetMillisecond: 100,
          );
          countDown10000ms = StopWatchTimer(
            mode: StopWatchMode.countDown,
            presetMillisecond: 10000,
          );
        });
        tearDown(() async {
          await countUp.dispose();
          await countDown100ms.dispose();
          await countDown10000ms.dispose();
        });
        group('CountUp', () {
          test('Should be running on start and not be on reset', () async {
            expect(countUp.isRunning, isFalse);
            countUp.onStartTimer();
            expect(countUp.isRunning, isTrue);
            countUp.onResetTimer();
            expect(countUp.isRunning, isFalse);
          });
          test('Should be running on start and not on stop', () async {
            expect(countUp.isRunning, isFalse);
            countUp.onStartTimer();
            expect(countUp.isRunning, isTrue);
            countUp.onStopTimer();
            expect(countUp.isRunning, isFalse);
          });

          test('Should be running on start and continue on lap', () async {
            expect(countUp.isRunning, isFalse);
            countUp.onStartTimer();
            expect(countUp.isRunning, isTrue);
            countUp.onAddLap();
            expect(countUp.isRunning, isTrue);
          });
        });
        group('CountDown', () {
          test('Should be running on start and not be on reset ', () async {
            expect(countDown10000ms.isRunning, isFalse);
            countDown10000ms.onStartTimer();
            expect(countDown10000ms.isRunning, isTrue);
            countDown10000ms.onResetTimer();
            expect(countDown10000ms.isRunning, isFalse);
          });
          test('Should be running on start and not on stop ', () async {
            expect(countDown10000ms.isRunning, isFalse);
            countDown10000ms.onStartTimer();
            expect(countDown10000ms.isRunning, isTrue);
            countDown10000ms.onStopTimer();
            expect(countDown10000ms.isRunning, isFalse);
          });
          test('Should be running on start and continue on lap ', () async {
            expect(countDown10000ms.isRunning, isFalse);
            countDown10000ms.onStartTimer();
            expect(countDown10000ms.isRunning, isTrue);
            countDown10000ms.onAddLap();
            expect(countDown10000ms.isRunning, isTrue);
          });
          test('Should be running on start and not when count down stops ',
              () async {
            expect(countDown100ms.isRunning, isFalse);
            countDown100ms.onStartTimer();
            expect(countDown100ms.isRunning, isTrue);
            await Future<void>.delayed(const Duration(milliseconds: 101));
            expect(countDown100ms.isRunning, isFalse);
          });
        });
      });
    });
  });
}
