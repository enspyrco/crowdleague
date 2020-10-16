import 'package:crowdleague/actions/navigation/store_nav_bar_selection.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class StoreNavBarSelectionReducer
    extends TypedReducer<AppState, StoreNavBarSelection> {
  StoreNavBarSelectionReducer()
      : super((state, action) =>
            state.rebuild((b) => b..navBarSelection = action.selection));
}
