library app_state;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/models/app/settings.dart';
import 'package:crowdleague/models/auth/vm_auth_page.dart';
import 'package:crowdleague/models/auth/vm_other_auth_options_page.dart';
import 'package:crowdleague/models/conversations/conversation/vm_conversation_page.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_page.dart';
import 'package:crowdleague/models/conversations/vm_conversation_summaries_page.dart';
import 'package:crowdleague/enums/nav_bar_selection.dart';
import 'package:crowdleague/models/navigation/problem.dart';
import 'package:crowdleague/models/navigation/route_info.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:crowdleague/models/app/serializers.dart';
import 'package:crowdleague/models/profile/vm_profile_page.dart';
import 'package:crowdleague/models/storage/storage_task_info.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  BuiltList<Problem> get problems;
  @nullable
  User get user;
  Settings get settings;
  NavBarSelection get navBarSelection;
  BuiltMap<String, StorageTaskInfo> get storageTasks;
  BuiltList<RouteInfo> get routes;
  VmOtherAuthOptionsPage get otherAuthOptionsPage;
  VmAuthPage get authPage;
  VmConversationSummariesPage get conversationSummariesPage;
  VmConversationPage get conversationPage;
  VmNewConversationPage get newConversationsPage;
  VmProfilePage get profilePage;

  AppState._();

  factory AppState.init() => AppState((a) => a
    ..problems = ListBuilder<Problem>()
    ..navBarSelection = NavBarSelection.home
    ..settings = Settings.initBuilder()
    ..authPage = VmAuthPage.initBuilder()
    ..otherAuthOptionsPage = VmOtherAuthOptionsPage.initBuilder()
    ..newConversationsPage = VmNewConversationPage.initBuilder()
    ..conversationPage.messageText = ''
    ..profilePage.pickingProfilePic = false);

  factory AppState([void Function(AppStateBuilder) updates]) = _$AppState;

  Object toJson() => serializers.serializeWith(AppState.serializer, this);

  static AppState fromJson(String jsonString) =>
      serializers.deserializeWith(AppState.serializer, json.decode(jsonString));

  static Serializer<AppState> get serializer => _$appStateSerializer;
}
