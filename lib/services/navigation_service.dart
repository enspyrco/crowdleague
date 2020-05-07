import 'package:crowdleague/models/navigation/problem.dart';
import 'package:crowdleague/widgets/shared/problem_alert.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class NavigationService {
  NavigationService(this._navKey);

  final GlobalKey<NavigatorState> _navKey;

  void navigateTo(String location) {
    /////////////////////////////////////////////////////////////////////////
    ///     From [Navigator.pushNamed] docs
    /////////////////////////////////////////////////////////////////////////
    ///
    /// Push a named route onto the navigator.
    ///
    /// The route name will be passed to that navigator's [onGenerateRoute]
    /// callback. The returned route will be pushed into the navigator.
    ///
    /// The new route and the previous route (if any) are notified (see
    /// [Route.didPush] and [Route.didChangeNext]). If the [Navigator] has any
    /// [Navigator.observers], they will be notified as well (see
    /// [NavigatorObserver.didPush]).
    ///
    /// Ongoing gestures within the current route are canceled when a new
    /// route is pushed.
    ///
    /// Returns a [Future] that completes to the result value passed to [pop]
    /// when the pushed route is popped off the navigator.
    ///
    /// The T type argument is the type of the return value of the route.
    ///
    /// To use [pushNamed], an [onGenerateRoute] callback must be provided,
    ///
    /// The provided arguments are passed to the pushed route via
    /// [RouteSettings.arguments]. Any object can be passed as arguments
    /// (e.g. a [String], [int], or an instance of a custom MyRouteArguments
    /// class). Often, a [Map] is used to pass key-value pairs.
    ///
    /// The arguments may be used in [Navigator.onGenerateRoute] or
    /// [Navigator.onUnknownRoute] to construct the route.

    _navKey.currentState.pushNamed(location);
  }

  void popHome() {
    _navKey.currentState.popUntil(ModalRoute.withName('/'));
  }

  void replaceCurrentWith(String newRouteName) {
    _navKey.currentState.pushReplacementNamed(newRouteName);
  }

  Future<Problem> display(Problem problem) {
    return showDialog<Problem>(
        context: _navKey.currentState.overlay.context,
        builder: (BuildContext context) {
          return ProblemAlert(
            problem: problem,
          );
        });
  }
}
