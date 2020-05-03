import 'package:crowdleague/models/leaguers/leaguer.dart';
import 'package:flutter/material.dart';

class LeaguerTile extends StatelessWidget {
  final Leaguer leaguer;

  LeaguerTile({@required this.leaguer, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(leaguer.photoUrl),
      title: Text(leaguer.name),
    );
  }
}
