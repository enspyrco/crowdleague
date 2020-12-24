import 'package:crowdleague/enums/navigation/nav_bar_selection.dart';
import 'package:crowdleague/widgets/conversations/conversation_summaries_page/conversation_summaries_page.dart';
import 'package:crowdleague/widgets/more_options/more_options_page.dart';
import 'package:crowdleague/widgets/venues/venues_page.dart';
import 'package:flutter/material.dart';

class MainPageBody extends StatelessWidget {
  final NavBarSelection selection;
  const MainPageBody({
    @required this.selection,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (selection) {
      case NavBarSelection.home:
        return Center(child: Text('Home Page'));
      case NavBarSelection.venues:
        return VenuesPage();
      case NavBarSelection.business:
        return Center(child: Text('Business Page'));
      case NavBarSelection.conversations:
        return ConversationSummariesPage();
      case NavBarSelection.more:
        return MoreOptionsPage();
      default:
        return Center(child: Text('Main Page'));
    }
  }
}
