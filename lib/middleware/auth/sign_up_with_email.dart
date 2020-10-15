import 'package:crowdleague/actions/auth/sign_up_with_email.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:redux/redux.dart';

class SignUpWithEmailMiddleware
    extends TypedMiddleware<AppState, SignUpWithEmail> {
  SignUpWithEmailMiddleware(AuthService authService)
      : super((store, action, next) async {
          next(action);

          authService
              .emailSignUpStream(store.state.emailAuthOptionsPage.email,
                  store.state.emailAuthOptionsPage.password)
              .listen(store.dispatch);
        });
}
