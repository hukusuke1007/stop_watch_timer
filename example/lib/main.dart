import 'package:flutter/material.dart';
import 'package:stop_watch_timer_example/count_down_timer_page.dart';
import 'package:stop_watch_timer_example/count_up_timer_page.dart';

void main() => runApp(
      const MyApp(),
    );

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilledButton(
                onPressed: () {
                  CountUpTimerPage.navigatorPush(context);
                },
                child: const Text('Count Up Timer'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilledButton(
                onPressed: () {
                  CountDownTimerPage.navigatorPush(context);
                },
                child: const Text('Count Down Timer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
