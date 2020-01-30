import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              /// Display stop watch time
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: 0,
                  builder: (context, snap) {
                    final value = snap.data;
                    final displayTime = _stopWatchTimer.getDisplayTime(value);
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
              /// Display every minute.
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: StreamBuilder<int>(
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
                                        fontSize: 40,
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
              ),
              /// Display every second.
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: StreamBuilder<int>(
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
                                      fontSize: 40,
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
              ),
              /// Lap time.
              Container(
                height: 300,
                margin: const EdgeInsets.all(8),
                child: StreamBuilder<List<StopWatchRecord>>(
                  stream: _stopWatchTimer.records,
                  initialData: const [],
                  builder: (context, snap) {
                    final value = snap.data;
                    if (value.isEmpty) {
                      return Container();
                    }
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut
                      );
                    });
                    print('Listen records. $value');
                    return ListView.builder(
                      controller: _scrollController,
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
              ),
              /// Button
              Padding(
                padding: const EdgeInsets.all(2),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: RaisedButton(
                              padding: const EdgeInsets.all(4),
                              color: Colors.lightBlue,
                              shape: const StadiumBorder(),
                              onPressed: () async {
                                _stopWatchTimer.start();
                              },
                              child: Text('Start', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: RaisedButton(
                              padding: const EdgeInsets.all(4),
                              color: Colors.green,
                              shape: const StadiumBorder(),
                              onPressed: () async {
                                _stopWatchTimer.stop();
                              },
                              child: Text('Stop', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: RaisedButton(
                              padding: const EdgeInsets.all(4),
                              color: Colors.red,
                              shape: const StadiumBorder(),
                              onPressed: () async {
                                _stopWatchTimer.reset();
                              },
                              child: Text('Reset', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: RaisedButton(
                              padding: const EdgeInsets.all(4),
                              color: Colors.deepPurpleAccent,
                              shape: const StadiumBorder(),
                              onPressed: () async {
                                _stopWatchTimer.lap();
                              },
                              child: Text('Lap', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
