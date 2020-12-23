import 'package:crowdleague/enums/navigation/nav_bar_selection.dart';
import 'package:crowdleague/widgets/main/main_page_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../utils/widget_test_harness.dart';

void main() {
  group('MainPageBody', () {
    testWidgets('shows venuesPage when appState.navBarSelection updates',
        (WidgetTester tester) async {
      // Setup a test harness.
      final harness = WidgetTestHarness(
        widgetUnderTest: MainPageBody(selection: NavBarSelection.venues),
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
