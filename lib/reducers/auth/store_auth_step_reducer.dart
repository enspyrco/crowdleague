import 'package:crowdleague/actions/auth/store_auth_step.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

class StoreAuthStepReducer extends TypedReducer<AppState, StoreAuthStep> {
  StoreAuthStepReducer()
      : super((state, action) => state.rebuild((b) => b
          ..authPage.step = action.step
          ..otherAuthOptionsPage.step = action.step));
}
