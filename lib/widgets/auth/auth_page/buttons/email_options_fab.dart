import 'package:crowdleague/actions/navigation/push_page.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/navigation/page_data/email_auth_page_data.dart';
import 'package:flutter/material.dart';

class EmailOptionsFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.email),
        elevation: 1,
        mini: true,
        onPressed: () => context.dispatch(PushPage(data: EmailAuthPageData())));
  }
}
