import 'package:crowdleague/actions/notifications/request_fcm_permissions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/services/notifications_service.dart';
import 'package:redux/redux.dart';

class RequestFCMPermissionsMiddleware
    extends TypedMiddleware<AppState, RequestFCMPermissions> {
  RequestFCMPermissionsMiddleware(NotificationsService notificationsService)
      : super((store, action, next) async {
          next(action);

          notificationsService.requestPermissions();
        });
}
