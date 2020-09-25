import 'package:crowdleague/actions/redux_action.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class VerifyDispatchMiddleware extends TypedMiddleware<AppState, ReduxAction> {
  static List<ReduxAction> actions = [];
  VerifyDispatchMiddleware()
      : super((store, action, next) async {
          next(action);
          actions.add(action);
        });
  bool received(ReduxAction action) => actions.contains(action);
}
