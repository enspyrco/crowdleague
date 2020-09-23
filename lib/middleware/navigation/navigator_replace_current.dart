import 'package:crowdleague/actions/navigation/navigator_replace_current.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:redux/redux.dart';

class NavigatorReplaceCurrentMiddleware
    extends TypedMiddleware<AppState, NavigatorReplaceCurrent> {
  NavigatorReplaceCurrentMiddleware(NavigationService navigationService)
      : super((store, action, next) async {
          next(action);

          //
          navigationService.replaceCurrentWith(action.newLocation);
        });
}
