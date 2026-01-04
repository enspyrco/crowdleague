import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:crowdleague/utils/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        backgroundColor: Theme.of(context).primaryColor,
        title: StreamBuilder<Map<String, Object?>?>(
            stream: locate<UserService>().profileDocStream,
            builder: (context, snapshot) {
              return Text(snapshot.data?['name'] as String? ?? '?',
                  style: Theme.of(context).textTheme.displayMedium!);
            }),
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: GestureDetector(
            child: Avatar(
                playerId: locate<UserService>().currentUserId!,
                picSize: PicSize.small),
            onTap: () {
              context.pushNamed('player-profile', pathParameters: {
                'id': locate<UserService>().currentUserId!
              });
            },
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Card(
            child: ListTile(
              title: const Text('Expand your crew'),
              onTap: () {
                context.push('/find-players');
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Sign Out'),
              onTap: () {
                locate<UserService>().signOut();
                context.replace('/signin');
              },
            ),
          )
        ],
      ),
    );
  }
}
