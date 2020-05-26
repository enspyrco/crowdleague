import 'package:crowdleague/actions/auth/observe_auth_state.dart';
import 'package:crowdleague/actions/auth/sign_in_with_apple.dart';
import 'package:crowdleague/actions/auth/sign_in_with_email.dart';
import 'package:crowdleague/actions/auth/sign_in_with_google.dart';
import 'package:crowdleague/actions/auth/sign_out_user.dart';
import 'package:crowdleague/actions/auth/sign_up_with_email.dart';
import 'package:crowdleague/actions/auth/update_other_auth_options_page.dart';
import 'package:crowdleague/enums/auth_step.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app/app_state.dart';

/// Middleware is used for a variety of things:
/// - Logging
/// - Async calls (database, network)
/// - Calling to system frameworks
///
/// These are performed when actions are dispatched to the Store
///
/// The output of an action can perform another action using the [NextDispatcher]
///
List<Middleware<AppState>> createAuthMiddleware({AuthService authService}) {
  return [
    TypedMiddleware<AppState, ObserveAuthState>(
      _observeAuthState(authService),
    ),
    TypedMiddleware<AppState, SignInWithGoogle>(
      _signInWithGoogle(authService),
    ),
    TypedMiddleware<AppState, SignInWithApple>(
      _signInWithApple(authService),
    ),
    TypedMiddleware<AppState, SignInWithEmail>(
      _signInWithEmail(authService),
    ),
    TypedMiddleware<AppState, SignUpWithEmail>(
      _signUpWithEmail(authService),
    ),
    TypedMiddleware<AppState, SignOutUser>(
      _signOutUser(authService),
    ),
  ];
}

void Function(
        Store<AppState> store, ObserveAuthState action, NextDispatcher next)
    _observeAuthState(AuthService authService) {
  return (Store<AppState> store, ObserveAuthState action,
      NextDispatcher next) async {
    next(action);

    // listen to the stream that emits actions on any auth change
    // and call dispatch on the action
    authService.streamOfStateChanges.listen(store.dispatch);
  };
}

void Function(
        Store<AppState> store, SignInWithGoogle action, NextDispatcher next)
    _signInWithGoogle(AuthService authService) {
  return (Store<AppState> store, SignInWithGoogle action,
      NextDispatcher next) async {
    next(action);

    // sign in and listen to the stream and dispatch actions
    authService.googleSignInStream.listen(store.dispatch);
  };
}

void Function(
        Store<AppState> store, SignInWithApple action, NextDispatcher next)
    _signInWithApple(AuthService authService) {
  return (Store<AppState> store, SignInWithApple action,
      NextDispatcher next) async {
    next(action);

    // sign in and listen to the stream and dispatch actions
    authService.appleSignInStream.listen(store.dispatch);
  };
}

void Function(
        Store<AppState> store, SignInWithEmail action, NextDispatcher next)
    _signInWithEmail(AuthService authService) {
  return (Store<AppState> store, SignInWithEmail action,
      NextDispatcher next) async {
    next(action);

    // set the UI to waiting
    store.dispatch(UpdateOtherAuthOptionsPage(
        (b) => b..step = AuthStep.signingInWithEmail));

    // attempt sign in then dispatch resulting action
    final dismissAuthPageOrDisplayProblem = await authService.signInWithEmail(
        store.state.otherAuthOptionsPage.email,
        store.state.otherAuthOptionsPage.password);

    store.dispatch(dismissAuthPageOrDisplayProblem);

    // finish by resetting the UI of the auth page
    store.dispatch(
        UpdateOtherAuthOptionsPage((b) => b..step = AuthStep.waitingForInput));
  };
}

void Function(
        Store<AppState> store, SignUpWithEmail action, NextDispatcher next)
    _signUpWithEmail(AuthService authService) {
  return (Store<AppState> store, SignUpWithEmail action, NextDispatcher next) {
    next(action);

    // set the UI to waiting
    store.dispatch(UpdateOtherAuthOptionsPage(
        (b) => b..step = AuthStep.signingUpWithEmail));

    // attempt sign up then dispatch resulting action
    authService
        .signUpWithEmail(store.state.otherAuthOptionsPage.email,
            store.state.otherAuthOptionsPage.password)
        .then<dynamic>(store.dispatch)
        .whenComplete(() => store.dispatch(UpdateOtherAuthOptionsPage(
            (b) => b..step = AuthStep.waitingForInput)));
  };
}

void Function(Store<AppState> store, SignOutUser action, NextDispatcher next)
    _signOutUser(AuthService authService) {
  return (Store<AppState> store, SignOutUser action,
      NextDispatcher next) async {
    next(action);

    // sign out and dispatch the resulting problem if there is one
    final actionAfterSignout = await authService.signOut();

    if (actionAfterSignout != null) {
      store.dispatch(actionAfterSignout);
    }
  };
}
