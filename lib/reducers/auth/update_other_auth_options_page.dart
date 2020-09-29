import 'package:crowdleague/actions/auth/update_other_auth_options_page.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

/// A single reducer for all OtherAuthOptionsViewModel members is less
/// efficient but requires less code (actions and reducers)
/// [UpdateOtherAuthOptions] contains values to be updated or null
class UpdateOtherAuthOptionsPageReducer
    extends TypedReducer<AppState, UpdateOtherAuthOptionsPage> {
  UpdateOtherAuthOptionsPageReducer()
      : super((state, action) => state.rebuild((a) {
              a.otherAuthOptionsPage.mode =
                  action.mode ?? a.otherAuthOptionsPage.mode;
              a.otherAuthOptionsPage.showPassword =
                  action.showPassword ?? a.otherAuthOptionsPage.showPassword;
              a.otherAuthOptionsPage.step =
                  action.step ?? a.otherAuthOptionsPage.step;
              a.otherAuthOptionsPage.email =
                  action.email ?? a.otherAuthOptionsPage.email;
              a.otherAuthOptionsPage.password =
                  action.password ?? a.otherAuthOptionsPage.password;
              a.otherAuthOptionsPage.repeatPassword = action.repeatPassword ??
                  a.otherAuthOptionsPage.repeatPassword;
            }));
}
