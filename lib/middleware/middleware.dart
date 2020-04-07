import 'package:crowdleague/models/actions/observe_auth_state.dart';
import 'package:crowdleague/models/actions/sign_in_with_apple.dart';
import 'package:crowdleague/models/actions/sign_in_with_google.dart';
import 'package:crowdleague/models/actions/sign_out_user.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app_state.dart';
import 'package:crowdleague/services/auth_service.dart';

/// Middleware is used for a variety of things:
/// - Logging
/// - Async calls (database, network)
/// - Calling to system frameworks
///
/// These are performed when actions are dispatched to the Store
///
/// The output of an action can perform another action using the [NextDispatcher]
///
List<Middleware<AppState>> createMiddleware({AuthService authService}) {
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

void Function(Store<AppState> store, SignOutUser action, NextDispatcher next)
    _signOutUser(AuthService authService) {
  return (Store<AppState> store, SignOutUser action,
      NextDispatcher next) async {
    next(action);

    // sign out and dispatch the resulting action
    authService.signOut().then(store.dispatch);
  };
}
