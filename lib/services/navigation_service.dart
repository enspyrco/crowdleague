import 'dart:async';

import 'package:crowdleague/actions/functions/acknowledge_processing_failure.dart';
import 'package:crowdleague/actions/navigation/remove_problem.dart';
import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/enums/problem_type.dart';
import 'package:crowdleague/models/app/problem.dart';
import 'package:crowdleague/widgets/shared/confirmation_alert.dart';
import 'package:crowdleague/widgets/shared/problem_alert.dart';
import 'package:flutter/material.dart';

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
    /// The [popHome] method calls [NavigatorState.popUntil], passing a
    /// [RoutePredicate] created with [ModalRoute.withName]('/')
    ///
    /// The [RoutePredicate] is used to pop until the condition is met
    ///
    _navKey.currentState.popUntil(ModalRoute.withName('/'));
  }

  void replaceCurrentWith(String newRouteName) {
    _navKey.currentState.pushReplacementNamed(newRouteName);
  }

  /// Display the problem and return a future that will complete with an action
  /// to be dispatched.
  /// EDIT: (changed to async which apparently avoids the problem)
  ///   - Add a call to the post-frame callbacks (so we avoid calling setState during a build).
  Future<ReduxAction> display(Problem problem) async {
    // create a completer whose future is returned and is passed in to
    // addPostFrameCallback and completed when showDialog completes
    final completer = Completer<ReduxAction>();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    final returnedProblem = await showDialog<Problem>(
        context: _navKey.currentState.overlay.context,
        builder: (BuildContext context) {
          return ProblemAlert(
            problem: problem,
          );
        });

    ReduxAction nextAction;
    switch (returnedProblem.type) {
      case ProblemType.processingFailure:
        nextAction = AcknowledgeProcessingFailure(
            (b) => b..id = returnedProblem.info['id'] as String);
        break;
      default:
        nextAction = RemoveProblem((b) => b..problem.replace(returnedProblem));
    }

    completer.complete(nextAction);

    return completer.future;
  }

  Future<bool> displayConfirmation(String question) async {
    // create a completer whose future is returned and is passed in to
    // addPostFrameCallback and completed when showDialog completes
    final completer = Completer<bool>();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    final response = await showDialog<bool>(
        context: _navKey.currentState.overlay.context,
        builder: (BuildContext context) {
          return ConfirmationAlert(
            question: question,
          );
        });
    completer.complete(response);
    // });
    return completer.future;
  }
}
