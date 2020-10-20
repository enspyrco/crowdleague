import 'package:crowdleague/actions/auth/sign_in_with_email.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:redux/redux.dart';

class SignInWithEmailMiddleware
    extends TypedMiddleware<AppState, SignInWithEmail> {
  SignInWithEmailMiddleware(AuthService authService)
      : super((store, action, next) async {
          next(action);

          authService
              .emailSignInStream(store.state.emailAuthOptionsPage.email,
                  store.state.emailAuthOptionsPage.password)
              .listen(store.dispatch);
        });
}
