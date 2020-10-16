import 'package:crowdleague/actions/conversations/update_new_conversation_page.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';
import 'package:flutter/material.dart';

class LeaguerTile extends StatelessWidget {
  final Leaguer leaguer;

  LeaguerTile({@required this.leaguer, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(leaguer.photoURL),
      title: Text(leaguer.displayName),
      onTap: () =>
          context.dispatch(UpdateNewConversationPage(selection: leaguer)),
    );
  }
}
