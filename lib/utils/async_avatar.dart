import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// An avatar widget that uses either a Storage path build a CircleAvatar that uses a MemoryImage.
class AsyncAvatar extends StatelessWidget {
  const AsyncAvatar({
    super.key,
    required this.bytesFuture,
    this.backgroundColor = Colors.black,
    this.size = 50,
  });

  final Future<Uint8List?> bytesFuture;
  final Color backgroundColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FutureBuilder<Uint8List?>(
          future: bytesFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return CircleAvatar(
                backgroundColor: backgroundColor,
                backgroundImage: MemoryImage(snapshot.data!),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
