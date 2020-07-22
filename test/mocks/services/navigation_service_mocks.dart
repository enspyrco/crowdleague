import 'dart:async';

import 'package:crowdleague/models/app/problem.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:mockito/mockito.dart';

class MockNavigationService extends Mock implements NavigationService {}

class FakeNavigationService extends Fake implements NavigationService {
  final Completer<ReduxAction> _completer;

  FakeNavigationService(Completer<ReduxAction> completer)
      : _completer = completer;

  @override
  Future<ReduxAction> display(Problem problem) => _completer.future;

  @override
  Future<bool> displayConfirmation(String question) {
    // TODO: implement displayConfirmation
    throw UnimplementedError();
  }

  @override
  void navigateTo(String location) {
    // TODO: implement navigateTo
  }

  @override
  void popHome() {
    // TODO: implement popHome
  }

  @override
  void replaceCurrentWith(String newRouteName) {
    // TODO: implement replaceCurrentWith
  }
}
