import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:screenshots/screenshots.dart';

void main() {
  group('CrowdLeague App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    // final counterTextFinder = find.byValueKey('counter');
    // final buttonFinder = find.byValueKey('increment');

    final buttonFinder = find.byType('AccountButton');

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

    test('Take screenshots', () async {
      final config = Config();
      await screenshot(driver, config, 'myscreenshot1');
      await driver.waitFor(buttonFinder);
      await driver.tap(buttonFinder);
      // had to set waitUntilNoTransientCallbacks or the call times out
      // TODO: need to get to the bottom of this, see issue #15
      await screenshot(driver, config, 'myscreenshot2',
          waitUntilNoTransientCallbacks: false);
    });
  });
}
