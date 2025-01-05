import 'package:crowdleague/messages/messages_screen.dart';
import 'package:crowdleague/notifications/notificatons_screen.dart';
import 'package:crowdleague/services/messaging_service.dart';
import 'package:crowdleague/utils/locator.dart';
import 'package:crowdleague/venues/venues_screen.dart';
import 'package:crowdleague/you/you_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    // Initialize the AppLifecycleListener class and pass a callback that
    // stores the latest FCM token.
    _lifecycleListener = AppLifecycleListener(
      onStateChange: (lifecycleState) async {
        if (lifecycleState == AppLifecycleState.resumed) {
          String? token = await locate<MessagingService>().getToken();
          if (token != null) {
            locate<MessagingService>().storeToken(token);
          }
        }
        // If the NotificationsScreen is open and there is a new Notification
        // we want to rebuild the screen.
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
      ][_currentPageIndex],
      floatingActionButton: _currentPageIndex == 0
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
