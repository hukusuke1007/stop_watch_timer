import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

void main() {
  const MethodChannel channel = MethodChannel('stop_watch_timer');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
