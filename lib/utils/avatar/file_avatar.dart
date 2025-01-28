import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// An avatar widget that uses either a File path build a CircleAvatar that
/// uses a FileImage.
///
/// On web NetworkImage is used as the returned XFile instance will contain a
/// network-accessible Blob URL (pointing to a location within the browser).
/// See https://pub.dev/packages/image_picker_for_web#use-the-plugin
class FileAvatar extends StatelessWidget {
  const FileAvatar({
    super.key,
    this.picPath,
    this.backgroundColor = Colors.black,
    this.size = 50,
  });

  final String? picPath;
  final Color backgroundColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          if (picPath != null && kIsWeb)
            SizedBox(
              width: size,
              height: size,
              child: CircleAvatar(
                backgroundColor: backgroundColor,
                backgroundImage: NetworkImage(picPath!),
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
        ],
      ),
    );
  }
}
