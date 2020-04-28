import 'package:flutter/material.dart';

class PrintingNavigatorObserver extends NavigatorObserver {
  List<Route<dynamic>> routeStack = List();

  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    routeStack.add(route);
    print(routeStack);
  }

  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    routeStack.removeLast();
    print(routeStack);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    routeStack.removeLast();
    print(routeStack);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    routeStack.removeLast();
    routeStack.add(newRoute);
    print(routeStack);
  }
}
