import 'dart:io';

import 'package:flutter/material.dart';

class UploadingProfileAvatar extends StatelessWidget {
  final String _filePath;

  UploadingProfileAvatar({String filePath}) : _filePath = filePath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(
        radius: 45,
        backgroundImage: Image.file(File(_filePath)).image,
      ),
    );
  }
}
