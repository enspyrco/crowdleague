import 'package:crowdleague/conversations/conversations_screen.dart';
import 'package:crowdleague/conversations/conversations_service.dart';
import 'package:crowdleague/notifications/notificatons_screen.dart';
import 'package:crowdleague/services/messaging_service.dart';
import 'package:crowdleague/notifications/notifications_service.dart';
import 'package:crowdleague/utils/locator.dart';
import 'package:crowdleague/venues/venues_screen.dart';
import 'package:crowdleague/you/you_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    // On resume, check for unviewed Notifications and unread Messages,
    // and store the latest FCM token.
    _lifecycleListener = AppLifecycleListener(
      onResume: () async {
        locate<MessagingService>().checkAndUpdateFcmTokenIfFresh();
        // If the NotificationsScreen is open we rebuild the screen, in case
        // there is a new Notification.
        if (_currentPageIndex == NavigationDestinations.notifications.index) {
          setState(() {});
          // Otherwise read the count of unviewed notifications and emit so
          // the listeners (Notifications badge) can update
        } else {
          locate<NotificationsService>().readAndEmitNotificationsViewed();
        }
        // If the ConversationsScreen is open we rebuild the screen, in case
        // there is a new Message.
        if (_currentPageIndex == NavigationDestinations.messages.index) {
          setState(() {});
        } else {
          locate<ConversationsService>().readAndEmitUnreadMessages();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Each time the HomeScreen is built we update the badge counts.
    locate<NotificationsService>().readAndEmitNotificationsViewed();
    locate<ConversationsService>().readAndEmitUnreadMessages();

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
              stream:
                  locate<NotificationsService>().numNotificationsViewedStream,
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
          StreamBuilder<int>(
              stream:
                  locate<ConversationsService>().numUnreadMessagesStream,
              builder: (context, snapshot) {
                int numUnread = snapshot.data ?? 0;
                return (numUnread == 0)
                    ? NavigationDestination(
                        selectedIcon: Icon(Icons.message),
                        icon: Icon(Icons.message_outlined),
                        label: NavigationDestinations.messages.description,
                      )
                    : NavigationDestination(
                        selectedIcon: Badge(
                            label: Text(numUnread.toString()),
                            child: Icon(Icons.message)),
                        icon: Badge(
                            label: Text(numUnread.toString()),
                            child: Icon(Icons.message_outlined)),
                        label: NavigationDestinations.messages.description,
                      );
              }),
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
        const ConversationsScreen(),
        const YouScreen(),
      ][_currentPageIndex],
      floatingActionButton:
          _currentPageIndex == NavigationDestinations.venues.index
              ? FloatingActionButton(
                  onPressed: () {
                    context.push('/select-new-venue-location');
                  },
                  backgroundColor: Colors.white,
                  child: Icon(Icons.add),
                )
              : const SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }
}
