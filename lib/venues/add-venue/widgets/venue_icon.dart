import 'dart:io';

import 'package:flutter/material.dart';

class VenueIcon extends StatelessWidget {
  const VenueIcon({required this.filePath, super.key});

  final String filePath;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 8,
      backgroundColor: Colors.red,
      child: CircleAvatar(
        radius: 7,
        backgroundImage: FileImage(File(filePath)),
      ),
    );
  }
}
