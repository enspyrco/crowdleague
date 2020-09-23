import 'package:crowdleague/actions/navigation/record_removed_route_info.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class RecordRemovedRouteInfoReducer
    extends TypedReducer<AppState, RecordRemovedRouteInfo> {
  RecordRemovedRouteInfoReducer()
      : super((state, action) =>
            state.rebuild((b) => b..routes.remove(action.info)));
}
