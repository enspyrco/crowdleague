import 'package:crowdleague/actions/auth/store_auth_step.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

/// Stores [AuthStep] that toggles UI in [AuthPage] and [EmailAuthOptionsPage]
class StoreAuthStepReducer extends TypedReducer<AppState, StoreAuthStep> {
  StoreAuthStepReducer()
      : super((state, action) => state.rebuild(
              (b) => b
                ..authPage.step = action.step
                ..emailAuthOptionsPage.step = action.step,
            ));
}
