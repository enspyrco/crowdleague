import 'package:crowdleague/messages/messages_screen.dart';
import 'package:crowdleague/notifications/notificatons_screen.dart';
import 'package:crowdleague/venues/venues_screen.dart';
import 'package:crowdleague/you/you_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.map),
            icon: Icon(Icons.map_outlined),
            label: 'Venues',
          ),
          NavigationDestination(
            selectedIcon: Badge(child: Icon(Icons.notifications_on_sharp)),
            icon: Badge(child: Icon(Icons.notifications_none_outlined)),
            label: 'Notifications',
          ),
          NavigationDestination(
            selectedIcon: Badge(label: Text('2'), child: Icon(Icons.message)),
            icon: Badge(label: Text('2'), child: Icon(Icons.message_outlined)),
            label: 'Messages',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_2_outlined),
            label: 'You',
          ),
        ],
      ),
      body: <Widget>[
        const VenuesScreen(),
        const NotificationsScreen(),
        const MessagesScreen(),
        const YouScreen(),
      ][currentPageIndex],
    );
  }
}
