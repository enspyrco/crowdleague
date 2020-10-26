library app_state;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/enums/nav_bar_selection.dart';
import 'package:crowdleague/models/app/system_info.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:crowdleague/models/auth/vm_auth_page.dart';
import 'package:crowdleague/models/auth/vm_email_auth_options_page.dart';
import 'package:crowdleague/models/conversations/conversation/vm_conversation_page.dart';
import 'package:crowdleague/models/conversations/new_conversation/vm_new_conversation_page.dart';
import 'package:crowdleague/models/conversations/vm_conversation_summaries_page.dart';
import 'package:crowdleague/models/functions/processing_failure.dart';
import 'package:crowdleague/models/navigation/page_data/initial_page_data.dart';
import 'package:crowdleague/models/navigation/page_data/page_data.dart';
import 'package:crowdleague/models/problems/problem.dart';
import 'package:crowdleague/models/profile/vm_profile_page.dart';
import 'package:crowdleague/models/settings/settings.dart';
import 'package:crowdleague/models/storage/upload_task.dart';
import 'package:crowdleague/utils/serializers.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  BuiltList<Problem> get problems;
  BuiltList<ProcessingFailure> get processingFailures;
  SystemInfo get systemInfo;
  @nullable
  User get user;
  BuiltList<PageData> get pagesData;
  Settings get settings;
  NavBarSelection get navBarSelection;
  BuiltMap<String, UploadTask> get uploadTasksMap;
  VmEmailAuthOptionsPage get emailAuthOptionsPage;
  VmAuthPage get authPage;
  VmConversationSummariesPage get conversationSummariesPage;
  VmConversationPage get conversationPage;
  VmNewConversationPage get newConversationsPage;
  VmProfilePage get profilePage;

  AppState._();

  factory AppState.init() => AppState((a) => a
    ..systemInfo.platform = PlatformType.checking
    ..pagesData = ListBuilder<PageData>(<PageData>[InitialPageData()])
    ..navBarSelection = NavBarSelection.home
    ..settings = Settings.initBuilder()
    ..authPage = VmAuthPage.initBuilder()
    ..emailAuthOptionsPage = VmEmailAuthOptionsPage.initBuilder()
    ..newConversationsPage = VmNewConversationPage.initBuilder()
    ..profilePage = VmProfilePage.initBuilder()
    ..conversationPage.messageText = '');

  factory AppState([void Function(AppStateBuilder) updates]) = _$AppState;

  Object toJson() => serializers.serializeWith(AppState.serializer, this);

  static AppState fromJson(String jsonString) =>
      serializers.deserializeWith(AppState.serializer, json.decode(jsonString));

  static Serializer<AppState> get serializer => _$appStateSerializer;
}
