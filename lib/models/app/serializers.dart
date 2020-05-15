import 'package:built_collection/built_collection.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:crowdleague/actions/navigation/add_problem.dart';
import 'package:crowdleague/actions/auth/clear_user_data.dart';
import 'package:crowdleague/actions/auth/observe_auth_state.dart';
import 'package:crowdleague/actions/auth/sign_in_with_email.dart';
import 'package:crowdleague/actions/auth/sign_up_with_email.dart';
import 'package:crowdleague/actions/auth/update_other_auth_options_page.dart';
import 'package:crowdleague/actions/notifications/print_fcm_token.dart';
import 'package:crowdleague/actions/notifications/request_fcm_permissions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/app/settings.dart';
import 'package:crowdleague/models/auth/provider_info.dart';
import 'package:crowdleague/models/auth/vm_auth_page.dart';
import 'package:crowdleague/models/auth/vm_other_auth_options_page.dart';
import 'package:crowdleague/models/conversations/conversation/message.dart';
import 'package:crowdleague/models/conversations/conversation/vm_conversation_page.dart';
import 'package:crowdleague/models/conversations/conversation_item.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_leaguers.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_page.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_selections.dart';
import 'package:crowdleague/models/conversations/vm_conversation_items_page.dart';
import 'package:crowdleague/models/enums/auth_step.dart';
import 'package:crowdleague/models/enums/email_auth_mode.dart';
import 'package:crowdleague/models/enums/nav_bar_selection.dart';
import 'package:crowdleague/models/enums/new_conversation_page_leaguers_state.dart';
import 'package:crowdleague/models/enums/problem_type.dart';
import 'package:crowdleague/models/enums/themes/brightness_mode.dart';
import 'package:crowdleague/models/enums/themes/theme_brightness.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';
import 'package:crowdleague/models/navigation/problem.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:crowdleague/models/navigation/route_info.dart';
import 'package:crowdleague/models/themes/theme_colors.dart';
import 'package:crowdleague/models/themes/theme_set.dart';

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
  UpdateOtherAuthOptionsPage,
  SignInWithEmail,
  SignUpWithEmail,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..add(Iso8601DateTimeSerializer())
      ..addBuilderFactory(const FullType(BuiltList, [FullType(Leaguer)]),
          () => ListBuilder<Leaguer>()))
    .build();
