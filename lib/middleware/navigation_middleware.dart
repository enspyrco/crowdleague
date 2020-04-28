import 'package:crowdleague/models/actions/navigation/navigate_to.dart';
import 'package:crowdleague/models/actions/navigation/navigator_pop_all.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:redux/redux.dart';
import 'package:crowdleague/models/app_state.dart';

/// Middleware is used for a variety of things:
/// - Logging
/// - Async calls (database, network)
/// - Calling to system frameworks
///
/// These are performed when actions are dispatched to the Store
///
/// The output of an action can perform another action using the [NextDispatcher]
///
List<Middleware<AppState>> createNavigationMiddleware(
    {NavigationService navigationService}) {
  return [
    TypedMiddleware<AppState, NavigateTo>(
      _navigateTo(navigationService),
    ),
    TypedMiddleware<AppState, NavigatorPopAll>(
      _navigatorPopAll(navigationService),
    ),
  ];
}

void Function(Store<AppState> store, NavigateTo action, NextDispatcher next)
    _navigateTo(NavigationService navigationService) {
  return (Store<AppState> store, NavigateTo action, NextDispatcher next) async {
    next(action);

    //
    navigationService.navigateTo(action.location);
  };
}

void Function(
        Store<AppState> store, NavigatorPopAll action, NextDispatcher next)
    _navigatorPopAll(NavigationService navigationService) {
  return (Store<AppState> store, NavigatorPopAll action,
      NextDispatcher next) async {
    next(action);

    //
    navigationService.popHome();
  };
}

// void Function(
//         Store<AppState> store, SignInWithGoogle action, NextDispatcher next)
//     _signInWithGoogle(AuthService authService) {
//   return (Store<AppState> store, SignInWithGoogle action,
//       NextDispatcher next) async {
//     next(action);

//     // sign in and listen to the stream and dispatch actions
//     authService.googleSignInStream.listen(store.dispatch);
//   };
// }

// void Function(
//         Store<AppState> store, SignInWithApple action, NextDispatcher next)
//     _signInWithApple(AuthService authService) {
//   return (Store<AppState> store, SignInWithApple action,
//       NextDispatcher next) async {
//     next(action);

//     // sign in and listen to the stream and dispatch actions
//     authService.appleSignInStream.listen(store.dispatch);
//   };
// }

// void Function(
//         Store<AppState> store, SignInWithEmail action, NextDispatcher next)
//     _signInWithEmail(AuthService authService) {
//   return (Store<AppState> store, SignInWithEmail action,
//       NextDispatcher next) async {
//     next(action);

//     // set the UI to waiting
//     store.dispatch(UpdateOtherAuthOptions(
//         (b) => b..step = EmailAuthStep.waitingForServer));

//     // attempt sign in then dispatch resulting action
//     authService
//         .signInWithEmail(store.state.otherAuthOptions.email,
//             store.state.otherAuthOptions.password)
//         .then(store.dispatch)
//         .whenComplete(() => store.dispatch(UpdateOtherAuthOptions(
//             (b) => b..step = EmailAuthStep.waitingForUser)));
//   };
// }

// void Function(
//         Store<AppState> store, SignUpWithEmail action, NextDispatcher next)
//     _signUpWithEmail(AuthService authService) {
//   return (Store<AppState> store, SignUpWithEmail action,
//       NextDispatcher next) async {
//     next(action);

//     // set the UI to waiting
//     store.dispatch(UpdateOtherAuthOptions(
//         (b) => b..step = EmailAuthStep.waitingForServer));

//     // attempt sign up then dispatch resulting action
//     authService
//         .signUpWithEmail(store.state.otherAuthOptions.email,
//             store.state.otherAuthOptions.password)
//         .then(store.dispatch)
//         .whenComplete(() => store.dispatch(UpdateOtherAuthOptions(
//             (b) => b..step = EmailAuthStep.waitingForUser)));
//   };
// }

// void Function(Store<AppState> store, SignOutUser action, NextDispatcher next)
//     _signOutUser(AuthService authService) {
//   return (Store<AppState> store, SignOutUser action,
//       NextDispatcher next) async {
//     next(action);

//     // sign out and dispatch the resulting action
//     authService.signOut().then(store.dispatch);
//   };
// }

// void Function(Store<AppState> store, RequestFCMPermissions action,
//         NextDispatcher next)
//     _requestNotificationPermissions(NotificationsService notificationsService) {
//   return (Store<AppState> store, RequestFCMPermissions action,
//       NextDispatcher next) async {
//     next(action);

//     notificationsService.requestPermissions();
//   };
// }

// void Function(Store<AppState> store, PrintFCMToken action, NextDispatcher next)
//     _printFCMToken(NotificationsService notificationsService) {
//   return (Store<AppState> store, PrintFCMToken action,
//       NextDispatcher next) async {
//     next(action);

//     notificationsService.printToken();
//   };
// }
