import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Auth section', () {
    final emailAuthButton = find.byType('EmailOptionsFAB');
    final emailTextField = find.byType('EmailTextField');
    final passwordTextField = find.byType('PasswordTextField');
    final emailSignInButton = find.byType('SignInButton');
    final emailValidationText = find.text('please enter a valid email');
    final passwordValidationText =
        find.text('password must be between 6 and 30 characters');
    final signInWithFirebaseText = find.text('signing in with firebase');
    final homePage = find.byType('MainPage');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      // if (driver != null) {
      //   await driver.close();
      // }
    });

    test('Sign in with email', () async {
      // navigate to email_auth_options_page
      await driver.waitFor(emailAuthButton);
      await driver.tap(emailAuthButton);

      // attempt entering details
      await driver.tap(emailTextField);
      await driver.enterText('invalid_email.com');

      await driver.tap(passwordTextField);
      await driver.enterText('p');

      await driver.tap(emailSignInButton);

      // observe validation errors
      await driver.waitFor(emailValidationText);
      await driver.waitFor(passwordValidationText);

      // correct validation errors
      await driver.tap(emailTextField);
      await driver.enterText('valid@email.com');

      await driver.tap(passwordTextField);
      await driver.enterText('password123');

      // observe autovalidation
      await driver.waitForAbsent(emailValidationText);
      await driver.waitForAbsent(passwordValidationText);

      // submit form
      await driver.tap(emailSignInButton);

      // observe signing in with firebase text
      await driver.waitForAbsent(signInWithFirebaseText);

      // observe navigation to home screen
      await driver.waitFor(homePage);
    });

    // test('Create an account', () async {
    // });

    // test('Sign out', () async {
    // });

    // test('Sign in with default provider', () async {
    // });

    // test('switch between email sign in/ sign up preserving text in textFields', () async {
    // });
  });
}
