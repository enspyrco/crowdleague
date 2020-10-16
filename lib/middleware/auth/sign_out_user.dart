import 'package:crowdleague/actions/auth/sign_out_user.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:redux/redux.dart';

class SignOutUserMiddleware extends TypedMiddleware<AppState, SignOutUser> {
  SignOutUserMiddleware(AuthService authService)
      : super((store, action, next) async {
          next(action);

          // sign out and dispatch the resulting problem if there is one
          final actionAfterSignout = await authService.signOut();

          // dispatch action to show any errors from signing out
          if (actionAfterSignout != null) store.dispatch(actionAfterSignout);
        });
}
