// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:crowdleague/services/venues_service.dart';
import 'package:crowdleague/utils/locator.dart';
import 'package:crowdleague/venues/add-venue/widgets/court_surface_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Court surface dropdown sets new venue map',
      (WidgetTester tester) async {
    Locator.add<VenuesService>(VenuesService());
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CourtSurfaceDropdown(),
        ),
      ),
    );

    // Verify that our dropdown starts at 1, ie. 'concrete'
    final droDownButton = find.byType(DropdownButton<String>);
    expect(droDownButton, findsOneWidget);
    expect(find.text('concrete'), findsOneWidget);
    expect(find.text('wood'), findsNothing);

    // the local venue stream emits a map that contains the 'surface' key with
    // value 1 because the CourtSurfaceDropdown widget sets the local venue in
    // the initState
    expect(locate<VenuesService>().localVenueStream.first,
        completion(containsPair('surface', 1)));

    // there appears to be no way to interact with the dropdown to check that
    // changing the value has the expected result.
    // see: https://github.com/flutter/flutter/issues/89905
  });
}
