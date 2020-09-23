import 'package:crowdleague/actions/navigation/record_added_route_info.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class RecordAddedRouteInfoReducer
    extends TypedReducer<AppState, RecordAddedRouteInfo> {
  RecordAddedRouteInfoReducer()
      : super((state, action) =>
            state.rebuild((b) => b..routes.add(action.info)));
}
