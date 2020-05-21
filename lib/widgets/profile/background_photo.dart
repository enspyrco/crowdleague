import 'package:flutter/material.dart';

class BackgroundPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.network(
        'https://cdn.osxdaily.com/wp-content/uploads/2009/08/defaultdesktop.jpg');
  }
}
