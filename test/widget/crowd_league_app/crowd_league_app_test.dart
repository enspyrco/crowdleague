import 'package:crowdleague/actions/auth/observe_auth_state.dart';
import 'package:crowdleague/actions/database/plumb_database_stream.dart';
import 'package:crowdleague/actions/device/check_platform.dart';
import 'package:crowdleague/actions/notifications/print_fcm_token.dart';
import 'package:crowdleague/actions/notifications/request_fcm_permissions.dart';
import 'package:crowdleague/reducers/navigation/push_page.dart';
import 'package:crowdleague/reducers/navigation/store_nav_bar_selection.dart';
import 'package:crowdleague/widgets/app/initializing_indicator.dart';
import 'package:crowdleague/widgets/auth/auth_page/auth_page.dart';
import 'package:crowdleague/widgets/auth/auth_page/buttons/email_options_fab.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/email_auth_options_page.dart';
import 'package:crowdleague/widgets/conversations/conversation_summaries_page/conversation_summaries_page.dart';
import 'package:crowdleague/widgets/main/account_button.dart';
import 'package:crowdleague/widgets/main/main_page.dart';
import 'package:crowdleague/widgets/more_options/more_options_page.dart';
import 'package:crowdleague/widgets/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../data/users_data.dart';
import '../../utils/completable_app_widget_harness.dart';

void main() {
  group('CrowdLeagueApp', () {
    testWidgets('shows expected UI while initializing',
        (WidgetTester tester) async {
      final harness = CompletableAppWidgetHarness();

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      final initializingIndicatorFinder = find.byType(InitializingIndicator);

      expect(initializingIndicatorFinder, findsOneWidget);

      // Verify the expected text is shown, indicating waiting for Firebase init
      expect(find.text('Enticing a ghost into the machine...'), findsOneWidget);

      harness.completeFirebase();

      await tester.pump();

      // Verify the expected text is shown, indicating waiting for redux init
      expect(find.text('Plumbing the pipes...'), findsOneWidget);

      harness.completeRedux();

      await tester.pump();

      expect(initializingIndicatorFinder, findsNothing);
    });

    testWidgets('dispatches actions after initialization',
        (WidgetTester tester) async {
      final harness = CompletableAppWidgetHarnessWithFakeStore();

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      final initializingIndicatorFinder = find.byType(InitializingIndicator);

      expect(initializingIndicatorFinder, findsOneWidget);

      // Verify the expected text is shown, indicating waiting for Firebase init.
      expect(find.text('Enticing a ghost into the machine...'), findsOneWidget);

      harness.completeFirebase();

      await tester.pump();

      // Verify the expected text is shown, indicating waiting for Redux init.
      expect(find.text('Plumbing the pipes...'), findsOneWidget);

      harness.completeRedux();

      await tester.pump();

      // Check we have moved past the waiting states.
      expect(initializingIndicatorFinder, findsNothing);

      // Check that all the expected actions were dispatched.
      expect(harness.receivedActions, contains(ObserveAuthState()));
      expect(harness.receivedActions, contains(RequestFCMPermissions()));
      expect(harness.receivedActions, contains(PrintFCMToken()));
      expect(harness.receivedActions, contains(CheckPlatform()));
      expect(harness.receivedActions, contains(PlumbDatabaseStream()));
    });

    testWidgets(
        'navigates to EmailAuthOptionsPage on FAB tap when user not signed in',
        (WidgetTester tester) async {
      final harness =
          CompletableAppWidgetHarnessWithStore(reducers: [PushPageReducer()]);

      harness.completeFirebase();
      harness.completeRedux();

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      // Build the widget tree and wait for animations to complete.
      await tester.pumpAndSettle();

      // Starting location of test.
      final initialPageFinder = find.byType(AuthPage);

      // Verify starting location.
      expect(initialPageFinder, findsOneWidget);

      // Find the button to tap.
      final fabFinder = find.byType(EmailOptionsFAB);

      // Tap the button.
      await tester.tap(fabFinder);

      // Wait for actions and animations to finish.
      await tester.pumpAndSettle();

      // Ending location of test.
      final nextPageFinder = find.byType(EmailAuthOptionsPage);

      // Verify ending location.
      expect(nextPageFinder, findsOneWidget);
    });
  });

  group('MainPage', () {
    testWidgets('navigates to ProfilePage on FAB tap',
        (WidgetTester tester) async {
      final harness = CompletableAppWidgetHarnessWithStore(
          appStateUpdates: (b) => b..user.replace(bobUser),
          reducers: [PushPageReducer()]);

      harness.completeFirebase();
      harness.completeRedux();

      // Build the widget tree.
      await tester.pumpWidget(harness.widget);

      await tester.pump();

      // Starting location of test.
      final initialPageFinder = find.byType(MainPage);

      // Verify starting location.
      expect(initialPageFinder, findsOneWidget);

      // Find the button to tap.
      final fabFinder = find.byType(AccountButton);

      // Tap the button.
      await tester.tap(fabFinder);

      // Ending location of test.
      final nextPageFinder = find.byType(ProfilePage);

      await tester.pump();

      // Verify ending location.
      expect(nextPageFinder, findsOneWidget);
    });

    testWidgets('navigates to "home page" on button tap',
        (WidgetTester tester) async {
      final harness = CompletableAppWidgetHarnessWithStore(
          appStateUpdates: (b) => b..user.replace(bobUser));

      harness.completeFirebase();
      harness.completeRedux();

      await tester.pumpWidget(harness.widget);

      await tester.pump();

      // Starting location of test.
      final initialPageFinder = find.byType(MainPage);

      // Verify starting location.
      expect(initialPageFinder, findsOneWidget);

      // Find the button to tap.
      final buttonFinder = find.byIcon(Icons.sports_basketball);

      // Tap the button.
      await tester.tap(buttonFinder);

      // Ending location of test.
      final nextPageFinder = find.text('Home Page');

      await tester.pump();

      // Verify ending location.
      expect(nextPageFinder, findsOneWidget);
    });

    testWidgets('navigates to "business page" on button tap',
        (WidgetTester tester) async {
      final harness = CompletableAppWidgetHarnessWithStore(
          appStateUpdates: (b) => b..user.replace(bobUser),
          reducers: [StoreNavBarSelectionReducer()]);

      harness.completeFirebase();
      harness.completeRedux();

      // Build the widget tree.
      await tester.pumpWidget(harness.widget);

      await tester.pump();

      // Starting location of test.
      final initialPageFinder = find.byType(MainPage);

      // Verify starting location.
      expect(initialPageFinder, findsOneWidget);

      // Find the button to tap.
      final buttonFinder = find.byIcon(Icons.business);

      // Tap the button.
      await tester.tap(buttonFinder);

      // Ending location of test.
      final nextPageFinder = find.text('Business Page');

      await tester.pump();

      // Verify ending location.
      expect(nextPageFinder, findsOneWidget);
    });

    testWidgets('navigates to ConversationSummariesPage on button tap',
        (WidgetTester tester) async {
      final harness = CompletableAppWidgetHarnessWithStore(
          appStateUpdates: (b) => b..user.replace(bobUser),
          reducers: [StoreNavBarSelectionReducer()]);

      harness.completeFirebase();
      harness.completeRedux();

      // Build the widget tree.
      await tester.pumpWidget(harness.widget);

      await tester.pump();

      // Starting location of test.
      final initialPageFinder = find.byType(MainPage);

      // Verify starting location.
      expect(initialPageFinder, findsOneWidget);

      // Find the button to tap.
      final buttonFinder = find.byIcon(Icons.message);

      // Tap the button.
      await tester.tap(buttonFinder);

      // Ending location of test.
      final nextPageFinder = find.byType(ConversationSummariesPage);

      await tester.pump();

      // Verify ending location.
      expect(nextPageFinder, findsOneWidget);
    });

    testWidgets('navigates to MoreOptionsPage on button tap',
        (WidgetTester tester) async {
      final harness = CompletableAppWidgetHarnessWithStore(
          appStateUpdates: (b) => b..user.replace(bobUser),
          reducers: [StoreNavBarSelectionReducer()]);

      harness.completeFirebase();
      harness.completeRedux();

      // Build the widget tree.
      await tester.pumpWidget(harness.widget);

      await tester.pump();
      // Starting location of test.
      final initialPageFinder = find.byType(MainPage);

      // Verify starting location.
      expect(initialPageFinder, findsOneWidget);

      // Find the button to tap.
      final buttonFinder = find.byIcon(Icons.more_vert);

      // Tap the button.
      await tester.tap(buttonFinder);

      // Ending location of test.
      final nextPageFinder = find.byType(MoreOptionsPage);

      await tester.pump();

      // Verify ending location.
      expect(nextPageFinder, findsOneWidget);
    });
  });
}
