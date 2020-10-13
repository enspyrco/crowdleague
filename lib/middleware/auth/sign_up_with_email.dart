import 'package:crowdleague/actions/auth/sign_up_with_email.dart';
import 'package:crowdleague/actions/auth/update_email_auth_options_page.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:redux/redux.dart';

class SignUpWithEmailMiddleware
    extends TypedMiddleware<AppState, SignUpWithEmail> {
  SignUpWithEmailMiddleware(AuthService authService)
      : super((store, action, next) async {
          next(action);

          // set the UI to waiting
          await store.dispatch(
              UpdateEmailAuthOptionsPage(step: AuthStep.signingUpWithEmail));

          // attempt sign up then dispatch resulting action
          final dismissAuthPageOrDisplayProblem =
              await authService.signUpWithEmail(
                  store.state.emailAuthOptionsPage.email,
                  store.state.emailAuthOptionsPage.password);

          await store.dispatch(dismissAuthPageOrDisplayProblem);

          // finish by resetting the UI of the auth page
          await store.dispatch(
              UpdateEmailAuthOptionsPage(step: AuthStep.waitingForInput));
        });
}
