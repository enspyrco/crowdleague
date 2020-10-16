import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

// e2e tests
// TODO: Check that signing in with google sets the profile pic url
//   - difficult as there is no local emulator for auth service yet

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
      // commented out so app can be manually used after test finishes
      // TODO: uncomment when test is no longer used for local dev
      // if (driver != null) {
      //   await driver.close();
      // }
    });

    test('Sign in', () async {
      await driver.waitFor(buttonFinder);
      await driver.tap(buttonFinder);
    });
  });
}
