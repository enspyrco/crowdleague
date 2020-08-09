import 'package:crowdleague/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('navigationService.display works when called during a build',
      (WidgetTester tester) async {
    final navKey = GlobalKey<NavigatorState>();
    final service = NavigationService(navKey);

    // I think there is too much mocking needed to make this worth
    // doing. Might be better to use an integration test for this.
  });
}
