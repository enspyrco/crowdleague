import 'package:crowdleague/messages/messages_screen.dart';
import 'package:crowdleague/notifications/notificatons_screen.dart';
import 'package:crowdleague/services/messaging_service.dart';
import 'package:crowdleague/utils/locator.dart';
import 'package:crowdleague/venues/venues_screen.dart';
import 'package:crowdleague/you/you_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/user_service.dart';
import 'enums/navigation_destinations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    // On resume, check for unviewed Notificaatios and store the latest FCM
    // token.
    _lifecycleListener = AppLifecycleListener(
      onStateChange: (lifecycleState) async {
        if (lifecycleState == AppLifecycleState.resumed) {
          String? token = await locate<MessagingService>().getToken();
          if (token != null) {
            locate<MessagingService>().storeToken(token);
          }

          // If the NotificationsScreen is open we rebuild the screen, in case
          // there is a new Notification.
          if (_currentPageIndex == NavigationDestinations.notifications.index) {
            setState(() {});
            // Otherwise read the count of unviewed notifications and emit so
            // the listeners (Notifications badge) can update
          } else {
            locate<UserService>().readAndEmitNotificationsViewed();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Each time the NotificationsScreen is built (ie. when the user taps
    // "Notifications") we update the unviewed notifications count for the badge.
    locate<UserService>().readAndEmitNotificationsViewed();

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        indicatorColor: Colors.grey.shade200,
        backgroundColor: Colors.grey.shade200,
        selectedIndex: _currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.map),
            icon: Icon(Icons.map_outlined),
            label: NavigationDestinations.venues.description,
          ),
          StreamBuilder<int>(
              stream: locate<UserService>().numNotificationsViewedStream,
              builder: (context, snapshot) {
                int numNotifications = snapshot.data ?? 0;
                return (numNotifications == 0)
                    ? NavigationDestination(
                        selectedIcon: Icon(Icons.notifications_on_sharp),
                        icon: Icon(Icons.notifications_none_outlined),
                        label: NavigationDestinations.notifications.description,
                      )
                    : NavigationDestination(
                        selectedIcon: Badge(
                            label: Text(numNotifications.toString()),
                            child: Icon(Icons.notifications_on_sharp)),
                        icon: Badge(
                            label: Text(numNotifications.toString()),
                            child: Icon(Icons.notifications_none_outlined)),
                        label: 'Notifications',
                      );
              }),
          NavigationDestination(
            selectedIcon: Badge(label: Text('2'), child: Icon(Icons.message)),
            icon: Badge(label: Text('2'), child: Icon(Icons.message_outlined)),
            label: NavigationDestinations.messages.description,
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_2_outlined),
            label: NavigationDestinations.you.description,
          ),
        ],
      ),
      body: <Widget>[
        const VenuesScreen(),
        const NotificationsScreen(),
        const MessagesScreen(),
        const YouScreen(),
      ][_currentPageIndex],
      floatingActionButton:
          _currentPageIndex == NavigationDestinations.venues.index
              ? FloatingActionButton(
                  onPressed: () {
                    context.push('/select-new-venue-location');
                  },
                  child: Icon(Icons.add),
                )
              : const SizedBox.shrink(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }
}
