# stop_watch_timer

This is Stop Watch Timer.

[https://pub.dev/packages/stop_watch_timer](https://pub.dev/packages/stop_watch_timer)

![demo](./demo.gif)

## Example code
See the example directory for a complete sample app using stop_watch_timer.

[example](https://github.com/hukusuke1007/stop_watch_timer/tree/master/example)

## Installation

Add this to your package's pubspec.yaml file:

```
dependencies:
  stop_watch_timer:
```


## Usage

```dart
import 'package:stop_watch_timer/stop_watch_timer.dart';  // Import stop_watch_timer

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(); // Create instance.

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();  // Need to call dispose function.
  }

  @override
  Widget build(BuildContext context) {
    ...
  }
}
```

To operation stop watch.

```dart
// Start
_stopWatchTimer.onExecute.add(StopWatchExecute.start);


// Stop
_stopWatchTimer.onExecute.add(StopWatchExecute.stop);


// Reset
_stopWatchTimer.onExecute.add(StopWatchExecute.reset);


// Lap time
_stopWatchTimer.onExecute.add(StopWatchExecute.lap);
```

### Using callback

```dart
final _stopWatchTimer = StopWatchTimer(
  onChange: (value) {
    final displayTime = StopWatchTimer.getDisplayTime(value);
    print('displayTime $displayTime');
  }
);
```

### Using stream

Display time formatted stop watch. Using function of "rawTime" and "getDisplayTime".

```dart
_stopWatchTimer.rawTime.listen((value) => print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
```

Example code using stream builder.

```dart
StreamBuilder<int>(
  stream: _stopWatchTimer.rawTime,
  initialData: 0,
  builder: (context, snap) {
    final value = snap.data;
    final displayTime = StopWatchTimer.getDisplayTime(value);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            displayTime,
            style: TextStyle(
              fontSize: 40,
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            value.toString(),
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Helvetica',
                fontWeight: FontWeight.w400
            ),
          ),
        ),
      ],
    );
  },
),
),
```

Notify from "secondTime" every second.

```dart
_stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
```

Example code using stream builder.

```dart
StreamBuilder<int>(
  stream: _stopWatchTimer.secondTime,
  initialData: 0,
  builder: (context, snap) {
    final value = snap.data;
    print('Listen every second. $value');
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'second',
                  style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Helvetica',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  value.toString(),
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          )
        ),
      ],
    );
  },
),
```

Notify from "minuteTime" every minute.

```dart
_stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
```

Example code using stream builder.

```dart
StreamBuilder<int>(
  stream: _stopWatchTimer.minuteTime,
  initialData: 0,
  builder: (context, snap) {
    final value = snap.data;
    print('Listen every minute. $value');
    return Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'minute',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Helvetica',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            )
        ),
      ],
    );
  },
),
```

Notify lap time.

```dart
_stopWatchTimer.records.listen((value) => print('records $value'));
```

Example code using stream builder.

```dart
StreamBuilder<List<StopWatchRecord>>(
  stream: _stopWatchTimer.records,
  initialData: const [],
  builder: (context, snap) {
    final value = snap.data;
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        final data = value[index];
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '${index + 1} ${data.displayTime}',
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            const Divider(height: 1,)
          ],
        );
      },
      itemCount: value.length,
    );
  },
),

```