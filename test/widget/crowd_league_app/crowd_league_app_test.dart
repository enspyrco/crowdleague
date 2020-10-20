import 'dart:async';

import 'package:crowdleague/actions/auth/observe_auth_state.dart';
import 'package:crowdleague/actions/database/plumb_database_stream.dart';
import 'package:crowdleague/actions/device/check_platform.dart';
import 'package:crowdleague/actions/navigation/push_page.dart';
import 'package:crowdleague/actions/notifications/print_fcm_token.dart';
import 'package:crowdleague/actions/notifications/request_fcm_permissions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/navigation/page_data/profile_page_data.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/widgets/app/crowd_league_app.dart';
import 'package:crowdleague/widgets/app/initializing_indicator.dart';
import 'package:crowdleague/widgets/auth/auth_page/auth_page.dart';
import 'package:crowdleague/widgets/auth/auth_page/buttons/email_options_fab.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page/email_auth_options_page.dart';
import 'package:crowdleague/widgets/main/account_button.dart';
import 'package:crowdleague/widgets/main/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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

    testWidgets('navigates to EmailAuthOptionsPage on FAB tap',
        (WidgetTester tester) async {
      // create a fake(ish) a services bundle
      final reduxCompleter = Completer<Store<AppState>>();
      final redux = FakeServicesBundle(completer: reduxCompleter);

      // create a fake firebase wrapper with a supplied completer
      final firebaseCompleter = Completer<FirebaseApp>();
      final firebase = FakeFirebaseWrapper(completer: firebaseCompleter);

      // the widget under test
      final wut = CrowdLeagueApp(redux: redux, firebase: firebase);

      // build the widget tree
      await tester.pumpWidget(wut);

      // complete the firebase future
      firebaseCompleter.complete();

      // setup a mock store and complete the redux future with the store
      final middleware = VerifyDispatchMiddleware();
      final store = Store<AppState>(appReducer,
          initialState: AppState.init(), middleware: [middleware]);
      reduxCompleter.complete(store);

      // build widget tree and wait for animations to complete
      await tester.pumpAndSettle();

      final initialPageFinder = find.byType(AuthPage);

      expect(initialPageFinder, findsOneWidget);

      final fabFinder = find.byType(EmailOptionsFAB);

      await tester.tap(fabFinder);

      await tester.pumpAndSettle();

      final nextPageFinder = find.byType(EmailAuthOptionsPage);

      expect(nextPageFinder, findsOneWidget);
    });

    testWidgets('navigates to profile page on profile avatar tap',
        (WidgetTester tester) async {
      // Setup the app state with expected values
      final initialAppState = AppState.init();
      final testMiddleware = VerifyDispatchMiddleware();

      // Create redux store.
      final store = Store<AppState>(appReducer,
          initialState: initialAppState, middleware: [testMiddleware]);

      // the widget under test
      final wut = MainPage();

      // Create the test harness.
      final harness =
          StoreProvider<AppState>(store: store, child: MaterialApp(home: wut));

      // build the widget tree
      await tester.pumpWidget(harness);

      final accountButtonFinder = find.byType(AccountButton);

      await tester.tap(accountButtonFinder);

      await tester.pumpAndSettle();

      expect(testMiddleware.received(PushPage(data: ProfilePageData())), true);
    });
  });
}
