import 'package:crowdleague/actions/navigation/display_problem.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:redux/redux.dart';

/// AddProblem actions trigger a call to display the problem, wait for the
/// display to be dismissed, then dispatch the onDismiss action held by the
/// Problem object
class DisplayProblemMiddleware
    extends TypedMiddleware<AppState, DisplayProblem> {
  DisplayProblemMiddleware(NavigationService navigationService)
      : super((store, action, next) async {
          next(action); // add the problem to the store

          // display the problem then remove from store when alert is dismissed
          final nextAction = await navigationService.display(action.problem);

          store.dispatch(nextAction);
        });
}
