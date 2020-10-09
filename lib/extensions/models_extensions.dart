import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/navigation/entries/email_auth_entry.dart';
import 'package:crowdleague/models/navigation/entries/initial_entry.dart';
import 'package:crowdleague/models/navigation/entries/navigator_entry.dart';
import 'package:crowdleague/widgets/auth/email_auth_options_page.dart';
import 'package:crowdleague/widgets/crowd_league_app.dart';
import 'package:flutter/material.dart';

/// We are using extensions in order to keep models as PODOs and avoid other
/// dependencies in the app state.
///
/// The challenge of trying to do polymorphism with extension methods, which is
/// already weird with built_value was getting quite difficult, so we have
/// gone with a big map for now and may come back to optimize in future.
extension NavigatorEntriesExt on BuiltList<NavigatorEntry> {
  static final Map<NavigatorEntry, MaterialPage> _pagesMap = {
    InitialEntry(): MaterialPage<AuthOrMain>(
        key: ValueKey(AuthOrMain), child: AuthOrMain()),
    EmailAuthEntry(): MaterialPage<EmailAuthOptionsPage>(
        key: ValueKey(EmailAuthOptionsPage), child: EmailAuthOptionsPage())
  };

  List<MaterialPage> toPages() =>
      map<MaterialPage>((entry) => _pagesMap[entry]).toList();
}
