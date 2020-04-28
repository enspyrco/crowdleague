import 'package:crowdleague/models/actions/auth/observe_auth_state.dart';
import 'package:crowdleague/models/actions/auth/sign_in_with_apple.dart';
import 'package:crowdleague/models/actions/auth/sign_in_with_email.dart';
import 'package:crowdleague/models/actions/auth/sign_in_with_google.dart';
import 'package:crowdleague/models/actions/auth/sign_out_user.dart';
import 'package:crowdleague/models/actions/auth/sign_up_with_email.dart';
import 'package:crowdleague/models/actions/auth/update_other_auth_options.dart';
import 'package:crowdleague/models/actions/bundle_of_actions.dart';
import 'package:crowdleague/models/actions/notifications/print_fcm_token.dart';
import 'package:crowdleague/models/actions/notifications/request_fcm_permissions.dart';
import 'package:crowdleague/models/app_state.dart';
import 'package:crowdleague/models/enums/email_auth_step.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:crowdleague/services/notifications_service.dart';
import 'package:redux/redux.dart';

/// Middleware is used for a variety of things:
/// - Logging
/// - Async calls (database, network)
/// - Calling to system frameworks
///
/// These are performed when actions are dispatched to the Store
///
/// The output of an action can perform another action using the [NextDispatcher]
///
List<Middleware<AppState>> createMiddleware(
    {AuthService authService, NotificationsService notificationsService}) {
  return [
    TypedMiddleware<AppState, BundleOfActions>(
      _unwrapBundleOfActions(),
    ),
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
    TypedMiddleware<AppState, RequestFCMPermissions>(
      _requestNotificationPermissions(notificationsService),
    ),
    TypedMiddleware<AppState, PrintFCMToken>(
      _printFCMToken(notificationsService),
    ),
  ];
}

void Function(
        Store<AppState> store, BundleOfActions action, NextDispatcher next)
    _unwrapBundleOfActions() {
  return (Store<AppState> store, BundleOfActions action, NextDispatcher next) {
    next(action);
    action.actions.forEach(store.dispatch);
  };
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
    store.dispatch(UpdateOtherAuthOptions(
        (b) => b..step = EmailAuthStep.waitingForServer));

    // attempt sign in then dispatch resulting action
    authService
        .signInWithEmail(store.state.otherAuthOptions.email,
            store.state.otherAuthOptions.password)
        .then(store.dispatch)
        .whenComplete(() => store.dispatch(UpdateOtherAuthOptions(
            (b) => b..step = EmailAuthStep.waitingForUser)));
  };
}

void Function(
        Store<AppState> store, SignUpWithEmail action, NextDispatcher next)
    _signUpWithEmail(AuthService authService) {
  return (Store<AppState> store, SignUpWithEmail action,
      NextDispatcher next) async {
    next(action);

    // set the UI to waiting
    store.dispatch(UpdateOtherAuthOptions(
        (b) => b..step = EmailAuthStep.waitingForServer));

    // attempt sign up then dispatch resulting action
    authService
        .signUpWithEmail(store.state.otherAuthOptions.email,
            store.state.otherAuthOptions.password)
        .then(store.dispatch)
        .whenComplete(() => store.dispatch(UpdateOtherAuthOptions(
            (b) => b..step = EmailAuthStep.waitingForUser)));
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

void Function(Store<AppState> store, RequestFCMPermissions action,
        NextDispatcher next)
    _requestNotificationPermissions(NotificationsService notificationsService) {
  return (Store<AppState> store, RequestFCMPermissions action,
      NextDispatcher next) async {
    next(action);

    notificationsService.requestPermissions();
  };
}

void Function(Store<AppState> store, PrintFCMToken action, NextDispatcher next)
    _printFCMToken(NotificationsService notificationsService) {
  return (Store<AppState> store, PrintFCMToken action,
      NextDispatcher next) async {
    next(action);

    notificationsService.printToken();
  };
}
