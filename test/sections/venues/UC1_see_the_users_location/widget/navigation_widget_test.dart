import 'package:crowdleague/actions/navigation/store_nav_bar_selection.dart';
import 'package:crowdleague/enums/navigation/nav_bar_selection.dart';
import 'package:crowdleague/widgets/main/nav_bar.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/widget_test_harness.dart';

void main() {
  group('navBar', () {
    testWidgets(
        'on tap venues page nav bar item, dispatch action to navigate to venues page ',
        (WidgetTester tester) async {
      // Setup a test harness.
      final harness = WidgetTestHarness(
        widgetUnderTest: NavBar(
          selectedIndex: 0,
        ),
      );

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      // Create the Finders.
      final venuesNavBarItem = find.text('Venues');

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that venuesNavBarItem is shown
      expect(venuesNavBarItem, findsOneWidget);

      await tester.tap(venuesNavBarItem);

      expect(
        harness.receivedActions,
        contains(
            StoreNavBarSelection(selection: NavBarSelection.valueOfIndex(1))),
      );
    });
  });
}
