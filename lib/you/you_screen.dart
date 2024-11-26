import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../utils/locator.dart';

const String profilePicPlaceholder =
    'https://media.istockphoto.com/id/1298261537/vector/blank-man-profile-head-icon-placeholder.jpg?s=612x612&w=0&k=20&c=CeT1RVWZzQDay4t54ookMaFsdi7ZHVFg2Y5v7hxigCA=';

class YouScreen extends StatefulWidget {
  const YouScreen({super.key});

  @override
  State<YouScreen> createState() => _YouScreenState();
}

class _YouScreenState extends State<YouScreen> {
  final Stream<Map<String, Object?>?> _profilePicDocStream =
      locate<FirestoreService>().documentStream(
          path: 'profilePics/${locate<AuthService>().currentUserId}');

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: SizedBox(
          width: 120,
          height: 120,
          child: StreamBuilder<Map<String, Object?>?>(
              stream: _profilePicDocStream,
              builder: (context, snapshot) {
                return CircleAvatar(
                  backgroundColor: Colors.yellow.shade800,
                  foregroundImage: NetworkImage(
                      snapshot.data?['large'] as String? ??
                          profilePicPlaceholder),
                );
              }),
        ),
        onPressed: () {
          context.push('/image-picker').then((value) {
            if (mounted) {
              setState(() {});
            }
          });
        },
      ),
    );
  }
}
