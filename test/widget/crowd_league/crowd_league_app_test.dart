import 'dart:async';

import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/utils/redux/services_bundle.dart';
import 'package:crowdleague/widgets/crowd_league_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/services/auth_service_mocks.dart';
import '../../mocks/services/database_service_mocks.dart';
import '../../mocks/services/storage_service_mocks.dart';
import '../../mocks/wrappers/firebase_wrapper_mocks.dart';

void main() {
  group('CrowddLeagueApp', () {
    testWidgets('shows expected UI while initializing',
        (WidgetTester tester) async {
      // create a fake(ish) a services bundle
      final redux = ServicesBundle(
          navKey: GlobalKey<NavigatorState>(),
          authService: FakeAuthService(),
          databaseService: FakeDatabaseService(),
          storageService: FakeStorageService(StreamController<ReduxAction>()));

      // create a fake firebase wrapper with a supplied completer
      final firebaseCompleter = Completer<FirebaseApp>();
      final firebase = FakeFirebaseWrapper(completer: firebaseCompleter);

      // the widget under test
      final wut = CrowdLeagueApp(
        redux: redux,
        firebase: firebase,
      );
      // Tell the tester to build the widget tree.
      await tester.pumpWidget(wut);

      // await tester.pumpAndSettle();

      // Create the Finders.
      final widgetFinder = find.byType(InitializingIndicator);

      // verify that the InitializingIndicator is shown
      expect(widgetFinder, findsOneWidget);

      // verify the expected text is shown, indicating waiting for both
      expect(find.text('Waiting for Redux & Firebase...'), findsOneWidget);

      // // complete the firebase future and check the text has changed as expected
      // firebaseCompleter.complete();

      // await tester.pump();

      // // expect(find.text('Waiting for Redux & Firebase...'), findsOneWidget);

      // // expect(find.text('Waiting for Redux...'), findsOneWidget);

      // expect(find.text('Waiting for Firebase...'), findsOneWidget);
    });
  });
}
