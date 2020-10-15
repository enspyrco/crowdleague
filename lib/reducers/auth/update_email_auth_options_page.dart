import 'package:crowdleague/actions/auth/update_email_auth_options_page.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:redux/redux.dart';

/// A single reducer for all [VmEmailAuthOptionsPage] members is less
/// efficient but requires less code (actions and reducers)
/// [UpdateEmailAuthOptionsPage] contains values to be updated or null
class UpdateEmailAuthOptionsPageReducer
    extends TypedReducer<AppState, UpdateEmailAuthOptionsPage> {
  UpdateEmailAuthOptionsPageReducer()
      : super((state, action) => state.rebuild((a) {
              a.emailAuthOptionsPage.mode =
                  action.mode ?? a.emailAuthOptionsPage.mode;
              a.emailAuthOptionsPage.showPassword =
                  action.showPassword ?? a.emailAuthOptionsPage.showPassword;
              a.emailAuthOptionsPage.step =
                  action.step ?? a.emailAuthOptionsPage.step;
              a.emailAuthOptionsPage.email =
                  action.email ?? a.emailAuthOptionsPage.email;
              a.emailAuthOptionsPage.password =
                  action.password ?? a.emailAuthOptionsPage.password;
              a.emailAuthOptionsPage.repeatPassword = action.repeatPassword ??
                  a.emailAuthOptionsPage.repeatPassword;
              a.emailAuthOptionsPage.autovalidate =
                  action.autovalidate ?? a.emailAuthOptionsPage.autovalidate;
            }));
}
