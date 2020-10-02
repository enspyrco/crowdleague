import 'dart:async';

import 'package:crowdleague/actions/auth/observe_auth_state.dart';
import 'package:crowdleague/actions/database/plumb_database_stream.dart';
import 'package:crowdleague/actions/device/check_platform.dart';
import 'package:crowdleague/actions/notifications/print_fcm_token.dart';
import 'package:crowdleague/actions/notifications/request_fcm_permissions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/widgets/crowd_league_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

import '../../mocks/wrappers/firebase_wrapper_mocks.dart';
import '../../utils/services_bundle_mocks.dart';
import '../../utils/verify_dispatch_middleware.dart';

void main() {
  group('CrowddLeagueApp', () {
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
  });
}
