import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('CrowdLeague App', () {
    final buttonFinder = find.byType('EmailOptionsFAB');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('Sign in', () async {
      await driver.waitFor(buttonFinder);
      await driver.tap(buttonFinder);
    });
  });
}
