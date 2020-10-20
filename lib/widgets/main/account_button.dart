import 'package:crowdleague/actions/navigation/push_page.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/navigation/page_data/profile_page_data.dart';
import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  const AccountButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.account_circle,
        size: 50,
      ),
      onPressed: () {
        context.dispatch(PushPage(data: ProfilePageData()));
      },
    );
  }
}
