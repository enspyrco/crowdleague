import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

/// [Middleware] that keeps track of actions that have been dispatched, for
/// testing.
///
/// [actions] is a static/class member so that it can be accessed in the
/// anonymous funciton that is created in the class initializer
class VerifyDispatchMiddleware extends TypedMiddleware<AppState, ReduxAction> {
  static List<ReduxAction> actions = [];
  VerifyDispatchMiddleware()
      : super((store, action, next) async {
          next(action);
          actions.add(action);
        }) {
    actions.clear();
  }
  bool received(ReduxAction action) => actions.contains(action);
  void clearActions() => actions.clear();
}
