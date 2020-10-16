import 'package:crowdleague/actions/notifications/print_fcm_token.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/notifications_service.dart';
import 'package:redux/redux.dart';

class PrintFCMTokenMiddleware extends TypedMiddleware<AppState, PrintFCMToken> {
  PrintFCMTokenMiddleware(NotificationsService notificationsService)
      : super((store, action, next) async {
          next(action);

          notificationsService.printToken();
        });
}
