import 'dart:io';

import 'package:crowdleague/utils/locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../players/enums/pic_size.dart';
import '../../players/models/player.dart';
import '../../players/players_service.dart';

/// A unified avatar widget that displays either:
/// - A player's profile picture (fetched by playerId)
/// - A local file image (for preview after camera/gallery selection)
/// - A placeholder icon when no image is available
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.playerId,
    this.picSize = PicSize.small,
    this.localFilePath,
    this.backgroundColor = Colors.black,
    this.size = 50,
  }) : assert(playerId != null || localFilePath != null,
            'Either playerId or localFilePath must be provided');

  /// Player ID to fetch profile picture from the server
  final String? playerId;

  /// Size variant for the profile picture URL
  final PicSize picSize;

  /// Local file path for displaying a picked image (camera/gallery)
  final String? localFilePath;

  final Color backgroundColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    // If local file path is provided, show that (used for preview after picking)
    if (localFilePath != null) {
      return _buildLocalFileAvatar();
    }

    // Otherwise fetch player and show their profile pic
    return _buildPlayerAvatar();
  }

  Widget _buildLocalFileAvatar() {
    final imageProvider = kIsWeb
        ? NetworkImage(localFilePath!) as ImageProvider
        : FileImage(File(localFilePath!));

    return SizedBox(
      width: size,
      height: size,
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        backgroundImage: imageProvider,
      ),
    );
  }

  Widget _buildPlayerAvatar() {
    return SizedBox(
      width: size,
      height: size,
      child: FutureBuilder<Player?>(
        future: locate<PlayersService>().retrievePlayer(playerId!),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.picId == 0) {
            return _buildPlaceholder();
          }

          final player = snapshot.data!;
          return CircleAvatar(
            backgroundColor: backgroundColor,
            backgroundImage:
                NetworkImage(player.constructProfilePicUrl(picSize)),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      child: Icon(Icons.person, color: Colors.white),
    );
  }
}
