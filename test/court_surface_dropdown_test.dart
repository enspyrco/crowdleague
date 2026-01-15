// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_functions/cloud_functions.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:crowdleague/venues/venues_service.dart';
import 'package:crowdleague/utils/locator.dart';
import 'package:crowdleague/venues/add-venue/widgets/court_surface_dropdown.dart';
import 'package:crowdleague/venues/models/local_venue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Court surface dropdown sets new venue map',
      (WidgetTester tester) async {
    final firestoreFake = FakeFirebaseFirestore();
    final fakeStorage = MockFirebaseStorage();
    final mockAuth = MockFirebaseAuth();
    final mockFunctions = MockFirebaseFunctions();

    Locator.add<VenuesService>(VenuesService(
      firestore: firestoreFake,
      storage: fakeStorage,
      cloudFunctions: mockFunctions,
      auth: mockAuth,
    ));

    final localVenue = LocalVenue();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CourtSurfaceDropdown(localVenue: localVenue),
        ),
      ),
    );

    // Verify that our dropdown starts at 1, ie. 'concrete'
    final droDownButton = find.byType(DropdownButton<String>);
    expect(droDownButton, findsOneWidget);
    expect(find.text('concrete'), findsOneWidget);
    expect(find.text('wood'), findsNothing);

    // there appears to be no way to interact with the dropdown to check that
    // changing the value has the expected result.
    // see: https://github.com/flutter/flutter/issues/89905
  });
}

/// Mock FirebaseFunctions for testing
class MockFirebaseFunctions implements FirebaseFunctions {
  @override
  HttpsCallable httpsCallable(String name, {HttpsCallableOptions? options}) {
    return MockHttpsCallable();
  }

  @override
  HttpsCallable httpsCallableFromUri(Uri uri, {HttpsCallableOptions? options}) {
    return MockHttpsCallable();
  }

  @override
  HttpsCallable httpsCallableFromUrl(String url,
      {HttpsCallableOptions? options}) {
    return MockHttpsCallable();
  }

  @override
  void useFunctionsEmulator(String host, int port,
      {bool automaticHostMapping = true}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockHttpsCallable implements HttpsCallable {
  @override
  Future<HttpsCallableResult<T>> call<T>([dynamic parameters]) async {
    return MockHttpsCallableResult<T>();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockHttpsCallableResult<T> implements HttpsCallableResult<T> {
  @override
  T get data => {} as T;
}
