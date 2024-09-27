import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/hoonar_camera.dart';

void main() {
  const MethodChannel channel = MethodChannel('bubbly_camera');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await HoonarCamera.platformVersion, '42');
  });
}
