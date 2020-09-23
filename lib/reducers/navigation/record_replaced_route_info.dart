import 'package:crowdleague/actions/navigation/record_replaced_route_info.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class RecordReplacedRouteInfoReducer
    extends TypedReducer<AppState, RecordReplacedRouteInfo> {
  RecordReplacedRouteInfoReducer()
      : super((state, action) => state.rebuild((b) => b
          ..routes.remove(action.oldInfo)
          ..routes.add(action.newInfo)));
}
