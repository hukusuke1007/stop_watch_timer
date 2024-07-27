import 'package:rxdart/rxdart.dart';
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
  const msTimeTolerance = 50;

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
    group('Method: dispose', () {
      test('Should close the streams', () async {
        // set up
        var rawTimeIsDone = false;
        var secondTimeIsDone = false;
        var minuteTimeIsDone = false;
        var recordIsDone = false;
        var fetchStoppedIsDone = false;
        var fetchEndedIsDone = false;
        final s = StopWatchTimer();
        s.rawTime.doOnDone(() => rawTimeIsDone = true).listen(null);
        s.secondTime.doOnDone(() => secondTimeIsDone = true).listen(null);
        s.minuteTime.doOnDone(() => minuteTimeIsDone = true).listen(null);
        s.records.doOnDone(() => recordIsDone = true).listen(null);
        s.fetchStopped.doOnDone(() => fetchStoppedIsDone = true).listen(null);
        s.fetchEnded.doOnDone(() => fetchEndedIsDone = true).listen(null);

// act
        await s.dispose();
        await Future<void>.delayed(Duration.zero);

        // checks
        expect(rawTimeIsDone, isTrue, reason: 'rawTime is not done.');
        expect(secondTimeIsDone, isTrue, reason: 'secondTime is not done.');
        expect(minuteTimeIsDone, isTrue, reason: 'minuteTime is not done.');
        expect(recordIsDone, isTrue, reason: 'records is not done.');
        expect(fetchStoppedIsDone, isTrue, reason: 'fetchStopped is not done.');
        expect(fetchEndedIsDone, isTrue, reason: 'fetchEnded is not done.');
      });

      test('Should throw exception if disposed multiple times', () async {
        final s = StopWatchTimer();
        await s.dispose();
        expect(s.dispose, throwsException);
        expect(s.dispose, throwsException);
      });
    });

    group('Method: onStartTimer', () {
      test('Should get updated raw time values for count up timer', () async {
        // set up
        final rawTimeValues = <int>[];
        var timesChanged = 0;
        final countUp = StopWatchTimer(onChange: (_) => timesChanged++);
        final rawTimeSubscription =
            countUp.rawTime.doOnData(rawTimeValues.add).listen(null);

        // initial check
        await Future<void>.delayed(Duration.zero);
        expect(rawTimeValues.length, equals(1));
        expect(rawTimeValues.last, equals(0));
        expect(timesChanged, equals(0));

        // act
        countUp.onStartTimer();

        // check: 0 ms
        await Future<void>.delayed(Duration.zero);
        expect(rawTimeValues.last, closeTo(0, 10));
        expect(timesChanged, equals(rawTimeValues.length - 1));

        // check: 100 ms
        await Future<void>.delayed(const Duration(milliseconds: 100));
        expect(rawTimeValues.last, closeTo(100, msTimeTolerance));
        expect(timesChanged, equals(rawTimeValues.length - 1));

        // check: 500 ms
        await Future<void>.delayed(const Duration(milliseconds: 400));
        expect(rawTimeValues.last, closeTo(500, msTimeTolerance));
        expect(timesChanged, equals(rawTimeValues.length - 1));

        // tear down
        await countUp.dispose();
        await rawTimeSubscription.cancel();
      });
      test('Should get updated second time values for count up timer ',
          () async {
        // set up
        final secondTimeValues = <int>[];
        var timesChanged = 0;
        final countUp =
            StopWatchTimer(onChangeRawSecond: (_) => timesChanged++);
        final secondTimeSubscription =
            countUp.secondTime.doOnData(secondTimeValues.add).listen(null);

        // initial check
        await Future<void>.delayed(Duration.zero);
        expect(secondTimeValues, orderedEquals([0]));
        expect(timesChanged, equals(0));

        // act
        countUp.onStartTimer();

        // check: 0 ms
        await Future<void>.delayed(Duration.zero);
        expect(secondTimeValues, orderedEquals([0]));
        expect(timesChanged, equals(0));

        // check: 500 ms
        await Future<void>.delayed(const Duration(milliseconds: 500));
        expect(secondTimeValues, orderedEquals([0]));
        expect(timesChanged, equals(0));

        // check: 1050 ms
        await Future<void>.delayed(const Duration(milliseconds: 550));
        expect(secondTimeValues, orderedEquals([0, 1]));
        expect(timesChanged, equals(1));

        // check: 3050 ms
        await Future<void>.delayed(const Duration(seconds: 2));
        expect(secondTimeValues, orderedEquals([0, 1, 2, 3]));
        expect(timesChanged, equals(3));

        // tear down
        await countUp.dispose();
        await secondTimeSubscription.cancel();
      });

      test(
        '(2 min) Should get updated minute time values for count up timer ',
        skip: 'Too long',
        () async {
          // set up
          final minuteTimeValues = <int>[];
          var timesChanged = 0;
          final countUp =
              StopWatchTimer(onChangeRawMinute: (_) => timesChanged++);
          final minuteTimeSubscription =
              countUp.minuteTime.doOnData(minuteTimeValues.add).listen(null);

          // initial check
          await Future<void>.delayed(Duration.zero);
          expect(minuteTimeValues, orderedEquals([0]));
          expect(timesChanged, equals(0));

          // act
          countUp.onStartTimer();

          // check: 0 ms
          await Future<void>.delayed(Duration.zero);
          expect(minuteTimeValues, orderedEquals([0]));
          expect(timesChanged, equals(0));

          // check: 500 ms
          await Future<void>.delayed(const Duration(milliseconds: 500));
          expect(minuteTimeValues, orderedEquals([0]));
          expect(timesChanged, equals(0));

          // check: 30 s
          await Future<void>.delayed(const Duration(seconds: 30));
          expect(minuteTimeValues, orderedEquals([0]));
          expect(timesChanged, equals(0));

          // check: 1 min
          await Future<void>.delayed(const Duration(seconds: 30));
          expect(minuteTimeValues, orderedEquals([0, 1]));
          expect(timesChanged, equals(1));

          // check: 2 min
          await Future<void>.delayed(const Duration(minutes: 1));
          expect(minuteTimeValues, orderedEquals([0, 1, 2]));
          expect(timesChanged, equals(2));

          // tear down
          await countUp.dispose();
          await minuteTimeSubscription.cancel();
        },
        tags: 'slow',
      );

      test('Should get updated second time values for count down timer ',
          () async {
        // set up
        final secondTimeValues = <int>[];
        var timesChanged = 0;
        final countUp = StopWatchTimer(
          onChangeRawSecond: (_) => timesChanged++,
          mode: StopWatchMode.countDown,
          presetMillisecond: 2500,
        );
        final secondTimeSubscription =
            countUp.secondTime.doOnData(secondTimeValues.add).listen(null);

        // initial check
        await Future<void>.delayed(Duration.zero);
        expect(secondTimeValues.length, equals(1));
        expect(secondTimeValues.last, equals(2));
        expect(timesChanged, equals(0));

        // act
        countUp.onStartTimer();

        // check: 0 ms
        await Future<void>.delayed(Duration.zero);
        expect(secondTimeValues, orderedEquals([2]));
        expect(timesChanged, equals(0));

        // check: 510 ms
        await Future<void>.delayed(const Duration(milliseconds: 510));
        expect(secondTimeValues, orderedEquals([2, 1]));
        expect(timesChanged, equals(1));

        // check: 1050 ms
        await Future<void>.delayed(const Duration(milliseconds: 540));
        expect(secondTimeValues, orderedEquals([2, 1]));
        expect(timesChanged, equals(1));

        // check: 2050 ms
        await Future<void>.delayed(const Duration(seconds: 1));
        expect(secondTimeValues, orderedEquals([2, 1, 0]));
        expect(timesChanged, equals(2));

        // check: 3050 ms
        await Future<void>.delayed(const Duration(seconds: 1));
        expect(secondTimeValues, orderedEquals([2, 1, 0]));
        expect(timesChanged, equals(2));

        // tear down
        await countUp.dispose();
        await secondTimeSubscription.cancel();
      });
    });

    group('Method: onResetTimer', () {
      test('Should emit nothing after resetting two times in a row', () async {
        // set up
        final rawTimeValues = <int>[];
        final secondTimeValues = <int>[];
        final minuteTimeValues = <int>[];
        var rawTimesChanged = 0;
        var secondTimesChanged = 0;
        var minuteTimesChanged = 0;
        final countUp = StopWatchTimer(
          onChange: (_) => rawTimesChanged++,
          onChangeRawMinute: (_) => minuteTimesChanged++,
          onChangeRawSecond: (_) => secondTimesChanged++,
        );
        final rawTimeSubscription =
            countUp.rawTime.doOnData(rawTimeValues.add).listen(null);
        final secondTimeSubscription =
            countUp.secondTime.doOnData(secondTimeValues.add).listen(null);
        final minuteTimeSubscription =
            countUp.minuteTime.doOnData(minuteTimeValues.add).listen(null);

        // initial check
        await Future<void>.delayed(Duration.zero);
        expect(rawTimeValues, orderedEquals([0]));
        expect(rawTimesChanged, equals(0));
        expect(secondTimeValues, orderedEquals([0]));
        expect(secondTimesChanged, equals(0));
        expect(minuteTimeValues, orderedEquals([0]));
        expect(minuteTimesChanged, equals(0));

        // act 1
        countUp.onResetTimer();

        // check after first reset
        await Future<void>.delayed(Duration.zero);
        expect(rawTimeValues, orderedEquals([0, 0]));
        expect(rawTimesChanged, equals(1));
        expect(secondTimeValues, orderedEquals([0]));
        expect(secondTimesChanged, equals(0));
        expect(minuteTimeValues, orderedEquals([0]));
        expect(minuteTimesChanged, equals(0));

        // act 2
        countUp.onResetTimer();

        // check after second reset
        await Future<void>.delayed(Duration.zero);
        expect(rawTimeValues, orderedEquals([0, 0, 0]));
        expect(rawTimesChanged, equals(2));
        expect(secondTimeValues, orderedEquals([0]));
        expect(secondTimesChanged, equals(0));
        expect(minuteTimeValues, orderedEquals([0]));
        expect(minuteTimesChanged, equals(0));

        // tear down
        await countUp.dispose();
        await rawTimeSubscription.cancel();
        await secondTimeSubscription.cancel();
        await minuteTimeSubscription.cancel();
      });
      test('Should get updated second time after reset', () async {
        // set up
        final secondTimeValues = <int>[];
        var timesChanged = 0;
        final countUp =
            StopWatchTimer(onChangeRawSecond: (_) => timesChanged++);
        final secondTimeSubscription =
            countUp.secondTime.doOnData(secondTimeValues.add).listen(null);

        // initial check
        await Future<void>.delayed(Duration.zero);
        expect(secondTimeValues, orderedEquals([0]));
        expect(timesChanged, equals(0));

        // act
        countUp.onStartTimer();

        // check: 1050 ms
        await Future<void>.delayed(const Duration(milliseconds: 1050));
        expect(secondTimeValues, orderedEquals([0, 1]));
        expect(timesChanged, equals(1));
        expect(countUp.isRunning, isTrue);

        countUp.onResetTimer();

        // Check immediately after resetting
        await Future<void>.delayed(Duration.zero);
        expect(secondTimeValues, orderedEquals([0, 1, 0]));
        expect(timesChanged, equals(2));
        expect(countUp.isRunning, isFalse);

        // check: 2050 ms
        await Future<void>.delayed(const Duration(seconds: 1));
        expect(secondTimeValues, orderedEquals([0, 1, 0]));
        expect(timesChanged, equals(2));

        // tear down
        await countUp.dispose();
        await secondTimeSubscription.cancel();
      });
    });

    group('Method: setPresetTime', () {
      group('CountUp', () {
        test(
            'Should have the correct raw time value when setting preset time for stopped count up',
            () async {
          // add == true
          const presetTime1 = 100;
          const presetTime2 = 300;
          // add == false
          const presetTime3 = 190;
          // add == true
          const presetTime4 = -100;
          const presetTime5 = -100000;

          final rawTimeValues = <int>[];
          var timesChanged = 0;
          final countUp = StopWatchTimer(onChange: (_) => timesChanged++);
          final rawTimeSubscription =
              countUp.rawTime.doOnData(rawTimeValues.add).listen(null);

          // initial check

          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(1));
          expect(rawTimeValues.last, equals(0));
          expect(timesChanged, equals(0));

          // act 1
          countUp.setPresetTime(mSec: presetTime1);

          // Check 1
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(2));
          expect(rawTimeValues.last, equals(presetTime1));
          expect(timesChanged, equals(1));

          // act 2
          countUp.setPresetTime(mSec: presetTime2);

          // Check 2
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(3));
          expect(rawTimeValues.last, equals(presetTime1 + presetTime2));
          expect(timesChanged, equals(2));

          // act 3
          countUp.setPresetTime(mSec: presetTime3, add: false);

          // Check 3
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(4));
          expect(rawTimeValues.last, equals(presetTime3));
          expect(timesChanged, equals(3));

          // act 4
          countUp.setPresetTime(mSec: presetTime4);

          // Check 4
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(5));
          expect(rawTimeValues.last, equals(presetTime3 + presetTime4));
          expect(timesChanged, equals(4));

          // act 5
          countUp.setPresetTime(mSec: presetTime5);

          // Check 5
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(6));
          expect(rawTimeValues.last, equals(0));
          expect(timesChanged, equals(5));

          // act 6
          countUp
            ..setPresetTime(mSec: 100, add: false) // reset
            ..setPresetTime(mSec: presetTime5, add: false);

          // Check 6
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(8));
          expect(rawTimeValues.last, equals(0));
          expect(timesChanged, equals(7));

          // tear down
          await countUp.dispose();
          await rawTimeSubscription.cancel();
        });

        test(
            'Should have the correct raw time value when setting preset time for started count up',
            () async {
          // started counter
          // add == true
          const waitTime1 = 250;
          const presetTime1 = 150;
          const waitTime2 = 500;
          const presetTime2 = -150;
          // add == false
          const waitTime3 = 150;
          const presetTime3 = 150;
          // stop timer
          const waitTime4 = 100;
          const presetTime4 = -150000;

          final rawTimeValues = <int>[];
          var timesChanged = 0;
          final countUp = StopWatchTimer(onChange: (_) => timesChanged++);
          final rawTimeSubscription =
              countUp.rawTime.doOnData(rawTimeValues.add).listen(null);

          countUp.onStartTimer();

          // act 1
          await Future<void>.delayed(const Duration(milliseconds: waitTime1));
          countUp.setPresetTime(mSec: presetTime1);

          // Check 1
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(timesChanged + 1));
          expect(rawTimeValues.last, closeTo(presetTime1 + waitTime1, 50));

          // act 2
          await Future<void>.delayed(const Duration(milliseconds: waitTime2));
          countUp.setPresetTime(mSec: presetTime2);

          // Check 2
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(timesChanged + 1));
          expect(
            rawTimeValues.last,
            closeTo(waitTime1 + presetTime1 + waitTime2 + presetTime2, 50),
          );

          // act 3
          await Future<void>.delayed(const Duration(milliseconds: waitTime3));
          countUp.setPresetTime(mSec: presetTime3, add: false);

          // Check 3
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(timesChanged + 1));
          expect(
            rawTimeValues.last,
            closeTo(waitTime1 + waitTime2 + waitTime3 + presetTime3, 50),
          );

          // act 4
          countUp.onStopTimer();
          await Future<void>.delayed(const Duration(milliseconds: waitTime4));
          countUp.setPresetTime(mSec: presetTime4);

          // Check 4
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(timesChanged + 1));
          expect(
            rawTimeValues.last,
            closeTo(0, 50),
          );

          // tear down
          await countUp.dispose();
          await rawTimeSubscription.cancel();
        });
      });

      group('CountDown', () {
        test(
            'Should have the correct raw time value when setting preset time for stopped count down',
            () async {
          // add == true
          const presetTime1 = 100;
          const presetTime2 = 300;
          // add == false
          const presetTime3 = 190;
          // add == true
          const presetTime4 = -100;
          const presetTime5 = -100000;

          final rawTimeValues = <int>[];
          var timesChanged = 0;
          final countUp = StopWatchTimer(
            onChange: (_) => timesChanged++,
            mode: StopWatchMode.countDown,
          );
          final rawTimeSubscription =
              countUp.rawTime.doOnData(rawTimeValues.add).listen(null);

          // initial check

          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(1));
          expect(rawTimeValues.last, equals(0));
          expect(timesChanged, equals(0));

          // act
          countUp.setPresetTime(mSec: presetTime1);

          // Check 1
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(2));
          expect(rawTimeValues.last, equals(presetTime1));
          expect(timesChanged, equals(1));

          // act 2
          countUp.setPresetTime(mSec: presetTime2);

          // Check 2
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(3));
          expect(rawTimeValues.last, equals(presetTime1 + presetTime2));
          expect(timesChanged, equals(2));

          // act 3
          countUp.setPresetTime(mSec: presetTime3, add: false);

          // Check 3
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(4));
          expect(rawTimeValues.last, equals(presetTime3));
          expect(timesChanged, equals(3));

          // act 4
          countUp.setPresetTime(mSec: presetTime4);

          // Check 4
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(5));
          expect(rawTimeValues.last, equals(presetTime3 + presetTime4));
          expect(timesChanged, equals(4));

          // act 5
          countUp.setPresetTime(mSec: presetTime5);

          // Check 5
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(6));
          expect(rawTimeValues.last, equals(0));
          expect(timesChanged, equals(5));

          // act 6
          countUp
            ..setPresetTime(mSec: 100, add: false) // reset
            ..setPresetTime(mSec: presetTime5, add: false);

          // Check 6
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(8));
          expect(rawTimeValues.last, equals(0));
          expect(timesChanged, equals(7));

          // tear down
          await countUp.dispose();
          await rawTimeSubscription.cancel();
        });

        test(
            'Should have the correct raw time value when setting preset time for started count down',
            () async {
          // started counter
          const initialPreset = 1000;
          // add == true
          const waitTime1 = 250;
          const presetTime1 = 150;
          const waitTime2 = 500;
          const presetTime2 = -150;
          // add == false
          const waitTime3 = 150;
          const presetTime3 = 1200;
          // stop timer
          const waitTime4 = 100;
          const presetTime4 = -150000;

          final rawTimeValues = <int>[];
          var timesChanged = 0;
          final countDown = StopWatchTimer(
            mode: StopWatchMode.countDown,
            onChange: (_) => timesChanged++,
            presetMillisecond: initialPreset,
          );
          final rawTimeSubscription =
              countDown.rawTime.doOnData(rawTimeValues.add).listen(null);

          countDown.onStartTimer();

          // act 1
          await Future<void>.delayed(const Duration(milliseconds: waitTime1));
          countDown.setPresetTime(mSec: presetTime1);

          // Check 1
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(timesChanged + 1));
          expect(rawTimeValues.last,
              closeTo(initialPreset + presetTime1 - waitTime1, 50));

          // act 2
          await Future<void>.delayed(const Duration(milliseconds: waitTime2));
          countDown.setPresetTime(mSec: presetTime2);

          // Check 2
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(timesChanged + 1));
          expect(
            rawTimeValues.last,
            closeTo(
              initialPreset +
                  presetTime1 +
                  presetTime2 -
                  (waitTime1 + waitTime2),
              50,
            ),
          );

          // act 3
          await Future<void>.delayed(const Duration(milliseconds: waitTime3));
          countDown.setPresetTime(mSec: presetTime3, add: false);

          // Check 3
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(timesChanged + 1));
          expect(
            rawTimeValues.last,
            closeTo(presetTime3 - (waitTime1 + waitTime2 + waitTime3), 50),
          );

          // act 4
          await Future<void>.delayed(const Duration(milliseconds: waitTime4));
          countDown.setPresetTime(mSec: presetTime4);

          // Check 4
          await Future<void>.delayed(Duration.zero);
          expect(rawTimeValues.length, equals(timesChanged + 1));
          expect(
            rawTimeValues.last,
            closeTo(0, 50),
          );
          expect(countDown.isRunning, isFalse);

          // tear down
          await countDown.dispose();
          await rawTimeSubscription.cancel();
        });
      });
    });

    group('Static methods', () {
      group('Method: getRawHours', () {
        const threeHoursInMilliseconds = 3 * oneHourInMilliseconds;

        final testCases = <Map<String, int>>[
          {'mSec': 0, 'expected': 0},
          {'mSec': 1, 'expected': 0},
          {'mSec': 1234, 'expected': 0},
          {'mSec': oneHourInMilliseconds - 1, 'expected': 0},
          {'mSec': oneHourInMilliseconds, 'expected': 1},
          {'mSec': oneHourInMilliseconds + 1, 'expected': 1},
          {'mSec': threeHoursInMilliseconds - 1, 'expected': 2},
          {'mSec': threeHoursInMilliseconds, 'expected': 3},
          {'mSec': threeHoursInMilliseconds + 1, 'expected': 3},
          {'mSec': maxHoursInMilliseconds - 1, 'expected': maxHours},
          {'mSec': maxHoursInMilliseconds, 'expected': maxHours},
        ];
        for (final item in testCases) {
          final mSec = item['mSec']!;
          final expectedRawHours = item['expected']!;
          test(
            'Should return $expectedRawHours h for input $mSec ms',
            () => expect(
              StopWatchTimer.getRawHours(mSec),
              equals(expectedRawHours),
            ),
          );
        }
      });

      group('Method: getMilliSecFromMinute', () {
        final testCases = <Map<String, int>>[
          {'min': 0, 'expected': 0},
          {'min': 1, 'expected': 60000},
          {'min': 10, 'expected': 600000},
        ];
        for (final item in testCases) {
          final min = item['min']!;
          final expectedTime = item['expected']!;
          test(
            'Should return $expectedTime ms for input $min min',
            () => expect(
              StopWatchTimer.getMilliSecFromMinute(min),
              equals(expectedTime),
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
          // pairwise test cases:
          // value = 0
          {
            // 0
            'input': [0, true, false, false, true, ':', ':', '.'],
            'expectedOutput': '0000',
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
            'expectedOutput': '3024',
          },
          {
            // 20
            'input': [time1, true, true, false, true, ':', 'min ', ''],
            'expectedOutput': '30:4198',
          },
          {
            // 21
            'input': [time1, false, true, true, false, '', ':', 's '],
            'expectedOutput': '1841:24',
          },
          {
            // 22
            'input': [time1, true, false, true, true, 'h ', '', '.'],
            'expectedOutput': '3024.98',
          },
          {
            // 23
            'input': [time1, false, true, false, true, ':', 'min ', ''],
            'expectedOutput': '184198',
          },
          {
            // 24
            'input': [time1, true, false, true, false, ':', ':', 's '],
            'expectedOutput': '3024',
          },
          {
            // 25
            'input': [time1, false, true, false, true, '', ':', '.'],
            'expectedOutput': '184198',
          },
          // value = max which is equivalent to 2501999792h 59min 00s 992ms
          {
            // 26
            'input': [maxInt, true, true, false, true, 'h ', 'min ', ''],
            'expectedOutput': '${maxHoursStr}h 5999',
          },
          {
            // 27
            'input': [maxInt, true, true, false, false, '', ':', '.'],
            'expectedOutput': '${maxHoursStr}59',
          },
          {
            // 28
            'input': [maxInt, true, false, true, true, 'h ', '', ''],
            'expectedOutput': '${maxHoursStr}0099',
          },
          {
            // 29
            'input': [maxInt, false, true, true, false, ':', 'min ', 's '],
            'expectedOutput': '150119987579min 00',
          },
          {
            // 30
            'input': [time1, true, false, false, false, 'hours', '', ''],
            'expectedOutput': '30',
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
