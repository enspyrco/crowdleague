import 'package:crowdleague/services/images_service.dart';
import 'package:crowdleague/utils/async_avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/user_auth_service.dart';
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
        backgroundColor: Theme.of(context).primaryColor,
        title: StreamBuilder<Map<String, Object?>?>(
            stream: locate<UserAuthService>().profileDocStream,
            builder: (context, snapshot) {
              return Text(snapshot.data?['name'] as String? ?? '?',
                  style: Theme.of(context).textTheme.displayMedium!);
            }),
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: GestureDetector(
            child: AsyncAvatar(
                bytesFuture: locate<ImagesService>().retrieveSmallProfilePic()),
            onTap: () {
              context.pushNamed('player-profile', pathParameters: {
                'id': locate<UserAuthService>().currentUserId!
              });
            },
          ),
        ),
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: const Text('Grow your crew'),
              onTap: () {
                context.push('/find-players');
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Sign Out'),
              onTap: () {
                locate<UserAuthService>().signOut();
                context.replace('/signin');
              },
            ),
          )
        ],
      ),
    );
  }
}
