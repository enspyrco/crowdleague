import 'package:crowdleague/actions/auth/observe_auth_state.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:redux/redux.dart';

class ObserveAuthStateMiddleware
    extends TypedMiddleware<AppState, ObserveAuthState> {
  ObserveAuthStateMiddleware(AuthService authService)
      : super((store, action, next) {
          next(action);

          // listen to the stream that emits actions on any auth change
          // and call dispatch on the action
          authService.streamOfStateChanges.listen(store.dispatch);
        });
}
