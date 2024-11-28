import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// An avatar widget that uses either a File path or a Url to build a
/// CircleAvatar that uses a FileImage or a NetworkImage. If neither is passed
/// a CircleAvatar with just a background color is built.
///
/// On web NetworkImage is used in both cases as the returned XFile instance
/// will contain a network-accessible Blob URL (pointing to a location within the browser).
/// See https://pub.dev/packages/image_picker_for_web#use-the-plugin
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.picPath,
    this.picUrl,
    this.backgroundColor = Colors.red,
    this.loading = false,
    this.size = 50,
  });

  final String? picPath;
  final String? picUrl;
  final Color backgroundColor;
  final bool loading;
  final int size;

  @override
  Widget build(BuildContext context) {
    if (picPath == null && picUrl == null) {
      return CircleAvatar(
        backgroundColor: backgroundColor,
      );
    }
    if (picPath != null && kIsWeb) {
      return CircleAvatar(
        backgroundColor: backgroundColor,
        backgroundImage: NetworkImage(picPath!),
      );
    }
    if (picPath == null) {
      return CircleAvatar(
        backgroundColor: backgroundColor,
        backgroundImage: NetworkImage(picUrl!),
      );
    } else {
      return CircleAvatar(
        backgroundColor: backgroundColor,
        foregroundImage: FileImage(File(picPath!)),
      );
    }
  }
}
