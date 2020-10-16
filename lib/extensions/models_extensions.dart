import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/navigation/page_data/email_auth_page_data.dart';
import 'package:crowdleague/models/navigation/page_data/initial_page_data.dart';
import 'package:crowdleague/models/navigation/page_data/messages_page_data.dart';
import 'package:crowdleague/models/navigation/page_data/new_conversation_page_data.dart';
import 'package:crowdleague/models/navigation/page_data/page_data.dart';
import 'package:crowdleague/models/navigation/page_data/profile_page_data.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page.dart';
import 'package:crowdleague/widgets/chats/messages/messages_page.dart';
import 'package:crowdleague/widgets/chats/new_conversation/new_conversation_page.dart';
import 'package:crowdleague/widgets/crowd_league_app.dart';
import 'package:crowdleague/widgets/profile/profile_page.dart';
import 'package:flutter/material.dart';

/// We are using extensions in order to keep models as PODOs and avoid other
/// dependencies in the app state.
///
/// The challenge of trying to do polymorphism with extension methods, which is
/// already weird with built_value was getting quite difficult, so we have
/// gone with a big map for now and may come back to optimize in future.
extension NavigatorEntriesExt on BuiltList<PageData> {
  static final Map<PageData, MaterialPage> _pagesMap = {
    InitialPageData(): MaterialPage<InitialPage>(
        key: ValueKey(InitialPage), child: InitialPage()),
    EmailAuthPageData(): MaterialPage<EmailAuthOptionsPage>(
        key: ValueKey(EmailAuthOptionsPage), child: EmailAuthOptionsPage()),
    ProfilePageData(): MaterialPage<ProfilePage>(
        key: ValueKey(ProfilePage), child: ProfilePage()),
    NewConversationPageData(): MaterialPage<NewConversationPage>(
        key: ValueKey(NewConversationPage), child: NewConversationPage()),
    MessagesPageData(): MaterialPage<MessagesPage>(
        key: ValueKey(MessagesPage), child: MessagesPage())
  };

  List<MaterialPage> toPages() =>
      map<MaterialPage>((entry) => _pagesMap[entry]).toList();
}
