import 'package:crowdleague/actions/auth/sign_in_with_apple.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:redux/redux.dart';

class SignInWithAppleMiddleware
    extends TypedMiddleware<AppState, SignInWithApple> {
  SignInWithAppleMiddleware(AuthService authService)
      : super((store, action, next) async {
          next(action);

          // sign in and listen to the stream and dispatch actions
          authService.appleSignInStream.listen(store.dispatch);
        });
}
