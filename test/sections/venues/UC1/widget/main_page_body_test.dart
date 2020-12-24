import 'package:crowdleague/enums/navigation/nav_bar_selection.dart';
import 'package:crowdleague/widgets/main/main_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/widget_test_harness.dart';

void main() {
  group('MainPage', () {
    testWidgets('shows venuesPage when appState.navBarSelection updates',
        (WidgetTester tester) async {
      // Setup a test harness with updated state
      final harness = WidgetTestHarness(
        stateUpdates: (b) => b..navBarSelection = NavBarSelection.venues,
        widgetUnderTest: MainPage(),
      );

      // Tell the tester to build the widget tree.
      await tester.pumpWidget(harness.widget);

      // Create the Finders.
      final venuesPage = find.text('Venues Page');

      // Use the `findsOneWidget` matcher provided by flutter_test to verify
      // that venuesPage is shown
      expect(venuesPage, findsOneWidget);
    });
  });
}
