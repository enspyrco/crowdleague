import 'package:crowdleague/actions/navigation/navigate_to.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/navigation_service.dart';
import 'package:redux/redux.dart';

class NavigateToMiddleware extends TypedMiddleware<AppState, NavigateTo> {
  NavigateToMiddleware(NavigationService navigationService)
      : super((store, action, next) async {
          next(action);

          //
          navigationService.navigateTo(action.location);
        });
}
