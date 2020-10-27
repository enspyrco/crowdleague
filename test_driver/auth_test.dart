import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Auth section', () {
    // create finders
    final emailAuthButton = find.byType('EmailOptionsFAB');
    final emailTextField = find.byType('EmailTextField');
    final passwordTextField = find.byType('PasswordTextField');
    final emailSignInButton = find.byType('SignInButton');
    final emailValidationText = find.text('please enter a valid email');
    final passwordValidationText =
        find.text('password must be between 6 and 30 characters');
    final signInWithFirebaseText = find.text('signing in with firebase');
    final mainPage = find.byType('MainPage');
    final authPage = find.byType('AuthPage');

    // Connect to the Flutter driver before running any tests.
    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    // Runs after successfull firebase/redux init
    test('signs in with email', () async {
      // Check that AuthPage is showing
      await driver.waitFor(authPage);

      // Navigate to EmailAuthOptionsPage
      await driver.tap(emailAuthButton);

      // Attempt entering email and password
      await driver.waitFor(emailTextField);
      await driver.tap(emailTextField);
      await driver.enterText('invalid_email.com');
      await driver.tap(passwordTextField);
      await driver.enterText('p');

      // Submit form with invalid details
      await driver.tap(emailSignInButton);

      // Check that validation errors are shown
      await driver.waitFor(emailValidationText);
      await driver.waitFor(passwordValidationText);

      // Correct validation errors
      await driver.tap(emailTextField);
      await driver.enterText('valid@email.com');
      await driver.tap(passwordTextField);
      await driver.enterText('password123');

      // Check that form autovalidated
      await driver.waitForAbsent(emailValidationText);
      await driver.waitForAbsent(passwordValidationText);

      // Submit valid form
      await driver.tap(emailSignInButton);

      // Check that signing in with firebase text is shown
      await driver.waitForAbsent(signInWithFirebaseText);

      // Check that app has navigated to MainPage
      await driver.waitFor(mainPage);
    });

    // Runs after leager has signed in successfully
    test('signs out', () async {
      // Check that main page is shown
      await driver.waitFor(mainPage);

      // Navigate to MoreOptionsPage
      await driver.tap(find.text('More'));
      await driver.waitFor(find.byType('MoreOptionsPage'));

      // Attempt to sign out
      final signOutButton = find.text('SIGN OUT');
      await driver.tap(signOutButton);

      // Check that AuthPage is shown on successfull sign out
      await driver.waitFor(authPage);
    });
  });
}
