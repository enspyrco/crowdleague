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
  }) : assert(!(picPath != null && picUrl != null));

  final String? picPath;
  final String? picUrl;
  final Color backgroundColor;
  final bool loading;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          if (picPath == null && picUrl == null)
            SizedBox(
              width: size,
              height: size,
              child: CircleAvatar(
                backgroundColor: backgroundColor,
              ),
            ),
          if (picPath != null && kIsWeb)
            SizedBox(
              width: size,
              height: size,
              child: CircleAvatar(
                backgroundColor: backgroundColor,
                backgroundImage: NetworkImage(picPath!),
              ),
            ),
          if (picUrl != null)
            SizedBox(
              width: size,
              height: size,
              child: CircleAvatar(
                backgroundColor: backgroundColor,
                backgroundImage: NetworkImage(picUrl!),
              ),
            ),
          if (picPath != null && !kIsWeb)
            SizedBox(
              width: size,
              height: size,
              child: CircleAvatar(
                backgroundColor: backgroundColor,
                foregroundImage: FileImage(File(picPath!)),
              ),
            ),
          if (loading)
            const SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
