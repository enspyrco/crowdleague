import 'package:crowdleague/actions/auth/sign_in_with_apple.dart';
import 'package:crowdleague/actions/auth/sign_in_with_google.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/widgets/auth/auth_page/auth_page.dart';
import 'package:crowdleague/widgets/auth/auth_page/buttons/apple_sign_in_fab.dart';
import 'package:crowdleague/widgets/auth/auth_page/buttons/auth_buttons.dart';
import 'package:crowdleague/widgets/auth/auth_page/buttons/google_sign_in_fab.dart';
import 'package:crowdleague/widgets/auth/auth_page/buttons/other_provider_fab.dart';
import 'package:crowdleague/widgets/auth/auth_page/buttons/platform_sign_in_button.dart';
import 'package:crowdleague/widgets/auth/auth_page/images/crowd_league_logo.dart';
import 'package:crowdleague/widgets/auth/auth_page/text/explanation_text.dart';
import 'package:crowdleague/widgets/auth/auth_page/text/tag_line_text.dart';
import 'package:crowdleague/widgets/shared/waiting_indicator.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/widget_test_harness.dart';

void main() {
  group('AuthPage', () {
    testWidgets('shows default UI while waiting for user input',
        (WidgetTester tester) async {
      // Setup a test harness.
      final harness = WidgetTestHarness(widgetUnderTest: AuthPage());

      // Check that we are in the expected initial state.
      expect(harness.state.authPage.step, AuthStep.waitingForInput);

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      // Create the Finders.
      final explanationText = find.byType(ExplanationText);
      final crowdLeagueLogo = find.byType(CrowdLeagueLogo);
      final taglineText = find.byType(TaglineText);
      final authButtons = find.byType(AuthButtons);

      // verify that the AuthPage UI is shown
      expect(explanationText, findsOneWidget);
      expect(crowdLeagueLogo, findsOneWidget);
      expect(taglineText, findsOneWidget);
      expect(authButtons, findsOneWidget);
    });

    testWidgets('displays without overflowing', (WidgetTester tester) async {
      // passing test indicates no overflowing as test suite uses a small device screen

      // Setup a test harness.
      final harness = WidgetTestHarness(widgetUnderTest: AuthPage());

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      // Create the Finders.
      final authPage = find.byType(AuthPage);

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that AuthPage is shown
      expect(authPage, findsOneWidget);
    });

    testWidgets('shows waiting indicator when signing in with google',
        (WidgetTester tester) async {
      // Setup a test harness.
      final harness = WidgetTestHarness(
          stateUpdates: (b) => b..authPage.step = AuthStep.signingInWithGoogle,
          widgetUnderTest: AuthPage());

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      // Show google waiting indicator
      final waitingIndicator = find.byType(WaitingIndicator);
      expect(waitingIndicator, findsOneWidget);

      final googleWaitingIndicatorText = find.text('Contacting Google...');
      expect(googleWaitingIndicatorText, findsOneWidget);
    });

    testWidgets('shows waiting indicator when signing in with apple',
        (WidgetTester tester) async {
      // Setup a test harness.
      final harness = WidgetTestHarness(
          stateUpdates: (b) => b..authPage.step = AuthStep.signingInWithApple,
          widgetUnderTest: AuthPage());

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      // Show apple waiting indicator
      final waitingIndicator = find.byType(WaitingIndicator);
      expect(waitingIndicator, findsOneWidget);

      // check that correct waiting text is shown
      final appleWaitingIndicatorText = find.text('Contacting Apple...');
      expect(appleWaitingIndicatorText, findsOneWidget);
    });

    testWidgets('shows waiting indicator when signing in with firebase',
        (WidgetTester tester) async {
      // Setup a test harness.
      final harness = WidgetTestHarness(
          stateUpdates: (b) =>
              b..authPage.step = AuthStep.signingInWithFirebase,
          widgetUnderTest: AuthPage());

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      // Show waiting indicator
      final waitingIndicator = find.byType(WaitingIndicator);
      expect(waitingIndicator, findsOneWidget);

      // check that correct waiting text is shown
      final firebaseWaitingIndicatorText =
          find.text('Signing in with CrowdLeague...');
      expect(firebaseWaitingIndicatorText, findsOneWidget);
    });

    testWidgets('shows "Sign In with Google" button on Android',
        (WidgetTester tester) async {
      // Setup a test harness.
      final harness = WidgetTestHarness(
          stateUpdates: (b) => b..systemInfo.platform = PlatformType.android,
          widgetUnderTest: AuthPage());

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      // Create the Finders.
      final googleSignInButton = find.byType(GoogleSignInButton);

      // dispatch action to set platform to android
      expect(googleSignInButton, findsOneWidget);
    });

    testWidgets('shows "Sign In with Apple" button on iOS',
        (WidgetTester tester) async {
      // Setup a test harness.
      final harness = WidgetTestHarness(
          stateUpdates: (b) => b..systemInfo.platform = PlatformType.ios,
          widgetUnderTest: AuthPage());

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      // Create the Finders.
      final appleSignInButton = find.byType(AppleSignInButton);

      // dispatch action to set platform to android
      expect(appleSignInButton, findsOneWidget);
    });

    testWidgets('dispatches SignInWithApple action on iOS',
        (WidgetTester tester) async {
      // Setup a test harness.
      final harness = WidgetTestHarness(
          stateUpdates: (b) => b..systemInfo.platform = PlatformType.ios,
          widgetUnderTest: AuthPage());

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      // Create the Finders.
      final platformSignIn = find.byType(PlatformSignInButton);
      expect(platformSignIn, findsOneWidget);

      // Tap to sign in
      await tester.tap(platformSignIn);

      // check correct action is dispatched
      expect(harness.receivedActions, contains(SignInWithApple()));
    });

    testWidgets('dispatches SignInWithGoogle action on Android',
        (WidgetTester tester) async {
      // Setup a test harness.
      final harness = WidgetTestHarness(
          stateUpdates: (b) => b..systemInfo.platform = PlatformType.android,
          widgetUnderTest: AuthPage());

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      // Create the Finders.
      final platformSignIn = find.byType(PlatformSignInButton);

      expect(platformSignIn, findsOneWidget);

      // Tap to sign in
      await tester.tap(platformSignIn);

      // check correct action is dispatched
      expect(harness.receivedActions, contains(SignInWithGoogle()));
    });

    testWidgets('shows "Sign In with Apple" FAB on Android',
        (WidgetTester tester) async {
      // Setup a test harness.
      final harness = WidgetTestHarness(
          stateUpdates: (b) => b..systemInfo.platform = PlatformType.android,
          widgetUnderTest: AuthPage());

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      // Create the Finders.
      final appleSignInFAB = find.byType(AppleSignInFAB);

      // check the button is found
      expect(appleSignInFAB, findsOneWidget);
    });

    testWidgets('shows "Sign In with Google" FAB on iOS',
        (WidgetTester tester) async {
      // Setup a test harness.
      final harness = WidgetTestHarness(
          stateUpdates: (b) => b..systemInfo.platform = PlatformType.ios,
          widgetUnderTest: AuthPage());

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      // Create the Finders.
      final googleSignInFAB = find.byType(GoogleSignInFAB);

      // dispatch action to set platform to android
      expect(googleSignInFAB, findsOneWidget);
    });

    testWidgets('dispatches SignInWithGoogle action on iOS',
        (WidgetTester tester) async {
      // Setup a test harness.
      final harness = WidgetTestHarness(
          stateUpdates: (b) => b..systemInfo.platform = PlatformType.ios,
          widgetUnderTest: AuthPage());

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      // Create the Finders.
      final otherPlatFormSignInButton = find.byType(OtherProviderFAB);
      expect(otherPlatFormSignInButton, findsOneWidget);

      // Tap to sign in
      await tester.tap(otherPlatFormSignInButton);

      // check correct action is dispatched
      expect(harness.receivedActions, contains(SignInWithGoogle()));
    });

    testWidgets('dispatches SignInWithApple action on Android',
        (WidgetTester tester) async {
      // Setup a test harness.
      final harness = WidgetTestHarness(
          stateUpdates: (b) => b..systemInfo.platform = PlatformType.android,
          widgetUnderTest: AuthPage());

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      // Create the Finders.
      final otherPlatFormSignInButton = find.byType(OtherProviderFAB);
      expect(otherPlatFormSignInButton, findsOneWidget);

      // Tap to sign in
      await tester.tap(otherPlatFormSignInButton);

      // check correct action is dispatched
      expect(harness.receivedActions, contains(SignInWithApple()));
    });
  });
}
