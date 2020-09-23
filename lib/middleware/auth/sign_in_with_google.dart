import 'package:crowdleague/actions/auth/sign_in_with_google.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:redux/redux.dart';

class SignInWithGoogleMiddleware
    extends TypedMiddleware<AppState, SignInWithGoogle> {
  SignInWithGoogleMiddleware(AuthService authService)
      : super((store, action, next) async {
          next(action);

          // sign in and listen to the stream and dispatch actions
          authService.googleSignInStream.listen(store.dispatch);
        });
}
