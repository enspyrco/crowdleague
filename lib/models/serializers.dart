import 'package:built_collection/built_collection.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:crowdleague/models/actions/add_problem.dart';
import 'package:crowdleague/models/actions/auth/clear_user_data.dart';
import 'package:crowdleague/models/actions/auth/observe_auth_state.dart';
import 'package:crowdleague/models/actions/auth/sign_in_with_email.dart';
import 'package:crowdleague/models/actions/auth/sign_up_with_email.dart';
import 'package:crowdleague/models/actions/auth/update_other_auth_options.dart';
import 'package:crowdleague/models/actions/notifications/print_fcm_token.dart';
import 'package:crowdleague/models/actions/notifications/request_fcm_permissions.dart';
import 'package:crowdleague/models/app_state.dart';
import 'package:crowdleague/models/enums/email_auth_mode.dart';
import 'package:crowdleague/models/enums/email_auth_step.dart';
import 'package:crowdleague/models/enums/problem_type.dart';
import 'package:crowdleague/models/other_auth_options_view_model.dart';
import 'package:crowdleague/models/problem.dart';
import 'package:crowdleague/models/provider_info.dart';
import 'package:crowdleague/models/user.dart';

part 'serializers.g.dart';

/// Once per app, define a top level "Serializer" to gather together
/// all the generated serializers.
///
/// Collection of generated serializers for the CrowdLeague app
@SerializersFor([
  AddProblem,
  AppState,
  ObserveAuthState,
  RequestFCMPermissions,
  PrintFCMToken,
  ClearUserData,
  UpdateOtherAuthOptions,
  SignInWithEmail,
  SignUpWithEmail,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..add(Iso8601DateTimeSerializer()))
    .build();
