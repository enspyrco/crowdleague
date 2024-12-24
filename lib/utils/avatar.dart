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
    this.picBytes,
    this.backgroundColor = Colors.black,
    this.loading = false,
    this.size = 50,
  });
  // : assert(!(picPath != null && picUrl != null && picBytes != null) &&
  //           loading == false), // can't all be null while not loading
  //       assert((picPath != null ||
  //           picUrl != null ||
  //           picBytes != null ||
  //           loading == true)); // one ( or more!?) must be non-null or loading
  // TODO: how to assert that 2 of them can't be non-null?

  final String? picPath;
  final String? picUrl;
  final Uint8List? picBytes;
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
          if (picBytes != null)
            SizedBox(
              width: size,
              height: size,
              child: CircleAvatar(
                backgroundColor: backgroundColor,
                backgroundImage: MemoryImage(picBytes!),
              ),
            ),
          if (picPath == null && picUrl == null && picBytes == null)
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
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
