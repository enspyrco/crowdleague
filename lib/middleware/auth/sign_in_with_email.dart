import 'package:crowdleague/actions/auth/sign_in_with_email.dart';
import 'package:crowdleague/actions/auth/update_other_auth_options_page.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:redux/redux.dart';

class SignInWithEmailMiddleware
    extends TypedMiddleware<AppState, SignInWithEmail> {
  SignInWithEmailMiddleware(AuthService authService)
      : super((store, action, next) async {
          next(action);

          // set the UI to waiting
          store.dispatch(UpdateOtherAuthOptionsPage(
              (b) => b..step = AuthStep.signingInWithEmail));

          // attempt sign in then dispatch resulting action
          final dismissAuthPageOrDisplayProblem =
              await authService.signInWithEmail(
                  store.state.otherAuthOptionsPage.email,
                  store.state.otherAuthOptionsPage.password);

          store.dispatch(dismissAuthPageOrDisplayProblem);

          // finish by resetting the UI of the auth page
          store.dispatch(UpdateOtherAuthOptionsPage(
              (b) => b..step = AuthStep.waitingForInput));
        });
}
