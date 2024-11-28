import 'package:crowdleague/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/firestore_service.dart';
import '../services/user_service.dart';
import '../utils/locator.dart';

class YouScreen extends StatefulWidget {
  const YouScreen({super.key});

  @override
  State<YouScreen> createState() => _YouScreenState();
}

class _YouScreenState extends State<YouScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade800,
        title: const Text(
          'nick',
          style: TextStyle(fontSize: 20),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: StreamBuilder<Map<String, Object?>?>(
              stream: locate<UserService>().profileDocStream,
              builder: (context, snapshot) {
                return (snapshot.data?['largePic'] == null)
                    ? CircleAvatar(backgroundColor: Colors.yellow.shade800)
                    : CircleAvatar(
                        backgroundColor: Colors.yellow.shade800,
                        foregroundImage:
                            NetworkImage(snapshot.data!['largePic'] as String),
                      );
              }),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.push('/image-picker').then((value) {
                  if (mounted) {
                    setState(() {});
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
