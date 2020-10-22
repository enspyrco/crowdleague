import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/auth/observe_auth_state.dart';
import 'package:crowdleague/actions/database/plumb_database_stream.dart';
import 'package:crowdleague/actions/device/check_platform.dart';
import 'package:crowdleague/actions/notifications/print_fcm_token.dart';
import 'package:crowdleague/actions/notifications/request_fcm_permissions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/auth/provider_info.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/widgets/app/crowd_league_app.dart';
import 'package:crowdleague/widgets/app/initializing_indicator.dart';
import 'package:crowdleague/widgets/auth/auth_page/auth_page.dart';
import 'package:crowdleague/widgets/auth/auth_page/buttons/email_options_fab.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/email_auth_options_page.dart';
import 'package:crowdleague/widgets/main/account_button.dart';
import 'package:crowdleague/widgets/main/main_page.dart';
import 'package:crowdleague/widgets/profile/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

import '../../mocks/wrappers/firebase_wrapper_mocks.dart';
import '../../utils/services_bundle_mocks.dart';
import '../../utils/verify_dispatch_middleware.dart';

void main() {
  group('CrowdLeagueApp', () {
    testWidgets('shows expected UI while initializing',
        (WidgetTester tester) async {
      // create a fake(ish) a services bundle
      final reduxCompleter = Completer<Store<AppState>>();
      final redux = FakeServicesBundle(completer: reduxCompleter);

      // create a fake firebase wrapper with a supplied completer
      final firebaseCompleter = Completer<FirebaseApp>();
      final firebase = FakeFirebaseWrapper(completer: firebaseCompleter);

      // the widget under test
      final wut = CrowdLeagueApp(redux: redux, firebase: firebase);

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(wut);

      // Create the Finders.
      final initializingIndicatorFinder = find.byType(InitializingIndicator);

      // verify that the InitializingIndicator is shown
      expect(initializingIndicatorFinder, findsOneWidget);

      // verify the expected text is shown, indicating waiting for both
      expect(find.text('Waiting for Firebase...'), findsOneWidget);

      // complete the firebase future and verfiy text has changed as expected
      firebaseCompleter.complete();
      await tester.pump();
      expect(find.text('Waiting for Redux...'), findsOneWidget);

      // complete the redux completer and verify
      reduxCompleter.complete();
      await tester.pump();

      // verify that the InitializingIndicator is no longer present
      expect(initializingIndicatorFinder, findsNothing);
    });

    testWidgets('dispatches actions after initialization',
        (WidgetTester tester) async {
      // create a fake(ish) a services bundle
      final reduxCompleter = Completer<Store<AppState>>();
      final redux = FakeServicesBundle(completer: reduxCompleter);

      // create a fake firebase wrapper with a supplied completer
      final firebaseCompleter = Completer<FirebaseApp>();
      final firebase = FakeFirebaseWrapper(completer: firebaseCompleter);

      // the widget under test
      final wut = CrowdLeagueApp(redux: redux, firebase: firebase);

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(wut);

      // complete the firebase future
      firebaseCompleter.complete();

      // setup a mock store and complete the redux future with the store
      final middleware = VerifyDispatchMiddleware();
      final store = Store<AppState>(appReducer,
          initialState: AppState.init(), middleware: [middleware]);
      reduxCompleter.complete(store);

      await tester.pumpAndSettle();

      expect(middleware.received(ObserveAuthState()), true);
      expect(middleware.received(RequestFCMPermissions()), true);
      expect(middleware.received(PrintFCMToken()), true);
      expect(middleware.received(CheckPlatform()), true);
      expect(middleware.received(PlumbDatabaseStream()), true);
    });

    testWidgets(
        'navigates to EmailAuthOptionsPage on FAB tap when user not signed in',
        (WidgetTester tester) async {
      // Create a fake(ish) services bundle.
      final reduxCompleter = Completer<Store<AppState>>();
      final redux = FakeServicesBundle(completer: reduxCompleter);

      // Create a fake firebase wrapper with a supplied completer.
      final firebaseCompleter = Completer<FirebaseApp>();
      final firebase = FakeFirebaseWrapper(completer: firebaseCompleter);

      // Widget being tested.
      final widgetUnderTest = CrowdLeagueApp(redux: redux, firebase: firebase);

      // Build the widget tree.
      await tester.pumpWidget(widgetUnderTest);

      // Complete the firebase future.
      firebaseCompleter.complete();

      // Setup a mock store and complete the redux future with the store.
      final middleware = VerifyDispatchMiddleware();
      final store = Store<AppState>(appReducer,
          initialState: AppState.init(), middleware: [middleware]);
      reduxCompleter.complete(store);

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

    testWidgets('MainPage navigates to ProfilePage on FAB tap',
        (WidgetTester tester) async {
      // Create a fake(ish) services bundle.
      final reduxCompleter = Completer<Store<AppState>>();
      final redux = FakeServicesBundle(completer: reduxCompleter);

      // Create a fake firebase wrapper with a supplied completer.
      final firebaseCompleter = Completer<FirebaseApp>();
      final firebase = FakeFirebaseWrapper(completer: firebaseCompleter);

      // Widget being tested.
      final widgetUnderTest = CrowdLeagueApp(redux: redux, firebase: firebase);

      // Build the widget tree.
      await tester.pumpWidget(widgetUnderTest);

      // Complete the firebase future.
      firebaseCompleter.complete();

      await tester.pump();

      // Create user for user sign in.
      final user = User(
          id: '1234',
          displayName: 'bob',
          photoURL: 'photo.com',
          email: 'test@email.com',
          providers: BuiltList<ProviderInfo>());

      // Setup a mock store and complete the redux future with the store.
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init().rebuild((b) => b..user.replace(user)),
      );
      reduxCompleter.complete(store);

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

    testWidgets('MainPage navigates to "home page" on button tap',
        (WidgetTester tester) async {
      // Create a fake(ish) services bundle.
      final reduxCompleter = Completer<Store<AppState>>();
      final redux = FakeServicesBundle(completer: reduxCompleter);

      // Create a fake firebase wrapper with a supplied completer.
      final firebaseCompleter = Completer<FirebaseApp>();
      final firebase = FakeFirebaseWrapper(completer: firebaseCompleter);

      // Widget being tested.
      final widgetUnderTest = CrowdLeagueApp(redux: redux, firebase: firebase);

      // Build the widget tree.
      await tester.pumpWidget(widgetUnderTest);

      // Complete the firebase future.
      firebaseCompleter.complete();

      await tester.pump();

      // Create user for user sign in.
      final user = User(
          id: '1234',
          displayName: 'bob',
          photoURL: 'photo.com',
          email: 'test@email.com',
          providers: BuiltList<ProviderInfo>());

      // Setup a mock store and complete the redux future with the store.
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init().rebuild((b) => b..user.replace(user)),
      );
      reduxCompleter.complete(store);

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
      final nextPageFinder = find.byWidget(Center(child: Text('Home Page')));

      await tester.pump();

      // Verify ending location.
      expect(nextPageFinder, findsOneWidget);
    });
  });
}
