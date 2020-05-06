import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/models/leaguers/leaguer.dart';
import 'package:flutter/material.dart';

class NewConversationSelectionsList extends StatelessWidget {
  final BuiltList<Leaguer> items;

  NewConversationSelectionsList({@required this.items, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) => CircleAvatar(
                backgroundImage: NetworkImage(
                  items[index].photoUrl,
                ),
                minRadius: 50,
              )),
    );
  }
}
