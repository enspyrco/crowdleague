import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';
import 'package:crowdleague/widgets/shared/leaguer_tile.dart';
import 'package:flutter/material.dart';

class NewConversationList extends StatelessWidget {
  final BuiltList<Leaguer> items;

  NewConversationList({@required this.items, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => LeaguerTile(
        leaguer: items[index],
      ),
    );
  }
}
