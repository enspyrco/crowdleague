import 'package:crowdleague/actions/navigation/navigator_pop_all.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:redux/redux.dart';

class NavigatorPopAllMiddleware
    extends TypedMiddleware<AppState, NavigatorPopAll> {
  NavigatorPopAllMiddleware(NavigationService navigationService)
      : super((store, action, next) async {
          next(action);

          //
          navigationService.popHome();
        });
}
