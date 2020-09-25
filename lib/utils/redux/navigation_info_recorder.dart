import 'package:crowdleague/actions/navigation/record_added_route_info.dart';
import 'package:crowdleague/actions/navigation/record_removed_route_info.dart';
import 'package:crowdleague/actions/navigation/record_replaced_route_info.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/navigation/route_info.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class NavigationInfoRecorder extends NavigatorObserver {
  Store<AppState> store;

  NavigationInfoRecorder(this.store);

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    store.dispatch(RecordAddedRouteInfo(
        info: RouteInfo(
            name: route.settings.name ?? route.runtimeType.toString(),
            arguments: route.settings.arguments)));
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    store.dispatch(RecordRemovedRouteInfo(
        info: RouteInfo(
            name: route.settings.name ?? route.runtimeType.toString(),
            arguments: route.settings.arguments)));
  }

  /// <-- Copied from [NavigatorObserver]. -->
  ///
  /// The [Navigator] removed route.
  ///
  /// If only one route is being removed, then the route immediately below that
  /// one, if any, is previousRoute.
  ///
  /// If multiple routes are being removed, then the route below the bottommost
  /// route being removed, if any, is previousRoute, and this method will be
  /// called once for each removed route, from the topmost route to the
  /// bottommost route.
  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    store.dispatch(RecordRemovedRouteInfo(
        info: RouteInfo(
            name: route.settings.name ?? route.runtimeType.toString(),
            arguments: route.settings.arguments)));
  }

  /// <-- Copied from [NavigatorObserver]. -->
  ///
  /// The [Navigator] replaced oldRoute with newRoute.
  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    store.dispatch(RecordReplacedRouteInfo(
        oldInfo: RouteInfo(
            name: oldRoute.settings.name ?? oldRoute.runtimeType.toString(),
            arguments: oldRoute.settings.arguments),
        newInfo: RouteInfo(
            name: newRoute.settings.name ?? newRoute.runtimeType.toString(),
            arguments: newRoute.settings.arguments)));
  }
}
