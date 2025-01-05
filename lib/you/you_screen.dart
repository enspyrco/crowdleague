import 'dart:typed_data';

import 'package:crowdleague/services/images_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/user_auth_service.dart';
import '../utils/avatar.dart';
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
          child: FutureBuilder<Uint8List?>(
              future: locate<ImagesService>().retrieveSmallProfilePic(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Avatar(picBytes: snapshot.data);
                } else {
                  return Avatar(loading: true);
                }
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
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: const Text('Add a Venue'),
              onTap: () {
                context.push('/select-new-venue-location');
              },
            ),
          ),
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
