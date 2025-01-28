import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// An avatar widget that uses image bytes in memory so is synchronous and fast.
class BytesAvatar extends StatelessWidget {
  const BytesAvatar(
    this.picBytes, {
    super.key,
    this.backgroundColor = Colors.black,
    this.widgetSize = 50,
  });

  final Color backgroundColor;
  final double widgetSize;
  final Uint8List picBytes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widgetSize,
      height: widgetSize,
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        backgroundImage: MemoryImage(picBytes),
      ),
    );
  }
}
