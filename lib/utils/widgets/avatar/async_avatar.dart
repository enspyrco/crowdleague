import 'package:crowdleague/utils/locator.dart';
import 'package:flutter/material.dart';

import '../../../players/enums/pic_size.dart';
import '../../../players/models/player.dart';
import '../../../players/players_service.dart';

/// An avatar widget that uses either a Storage path build a CircleAvatar that uses a MemoryImage.
class AsyncAvatar extends StatelessWidget {
  const AsyncAvatar(
    this.playerId,
    this.picSize, {
    super.key,
    this.backgroundColor = Colors.black,
    this.widgetSize = 50,
  });

  final Color backgroundColor;
  final double widgetSize;
  final String playerId;
  final PicSize picSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widgetSize,
        height: widgetSize,
        child: FutureBuilder<Player?>(
            future: locate<PlayersService>().retrievePlayer(playerId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return CircleAvatar(
                backgroundColor: backgroundColor,
                backgroundImage: NetworkImage(locate<PlayersService>()
                    .getProfilePicUrl(snapshot.data!, picSize)),
              );
            }));
  }
}
