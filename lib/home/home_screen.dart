import 'package:crowdleague/conversations/conversations_screen.dart';
import 'package:crowdleague/conversations/conversations_service.dart';
import 'package:crowdleague/notifications/notificatons_screen.dart';
import 'package:crowdleague/services/messaging_service.dart';
import 'package:crowdleague/services/tutorial_notifier.dart';
import 'package:crowdleague/notifications/notifications_service.dart';
import 'package:crowdleague/utils/locator.dart';
import 'package:crowdleague/venues/venues_screen.dart';
import 'package:crowdleague/you/you_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'enums/navigation_destinations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;
  late final AppLifecycleListener _lifecycleListener;

  // Tutorial keys for targeting UI elements
  final GlobalKey _venuesTabKey = GlobalKey();
  final GlobalKey _notificationsTabKey = GlobalKey();
  final GlobalKey _messagesTabKey = GlobalKey();
  final GlobalKey _youTabKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();

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

    // Show tutorial on first launch after onboarding
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final tutorialShown = prefs.getBool('tutorialShown') ?? false;
      if (!tutorialShown && mounted) {
        _showTutorial();
        await prefs.setBool('tutorialShown', true);
      } else {
        // Tutorial already shown, enable location immediately
        locate<TutorialNotifier>().markComplete();
      }
    });
  }

  void _showTutorial() {
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'venues',
        keyTarget: _venuesTabKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Venues',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Find local sports venues on the map',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'fab',
        keyTarget: _fabKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Venue',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Tap here to add new venues you discover',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'notifications',
        keyTarget: _notificationsTabKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Get notified when players want to play',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'messages',
        keyTarget: _messagesTabKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Messages',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Chat with other players',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'you',
        keyTarget: _youTabKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Manage your profile and crews',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    ];

    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: 'SKIP',
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        locate<TutorialNotifier>().markComplete();
      },
      onSkip: () {
        locate<TutorialNotifier>().markComplete();
        return true;
      },
    ).show(context: context);
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
          KeyedSubtree(
            key: _venuesTabKey,
            child: NavigationDestination(
              selectedIcon: Icon(Icons.map),
              icon: Icon(Icons.map_outlined),
              label: NavigationDestinations.venues.description,
            ),
          ),
          KeyedSubtree(
            key: _notificationsTabKey,
            child: StreamBuilder<int>(
                stream:
                    locate<NotificationsService>().numNotificationsViewedStream,
                builder: (context, snapshot) {
                  int numNotifications = snapshot.data ?? 0;
                  return (numNotifications == 0)
                      ? NavigationDestination(
                          selectedIcon: Icon(Icons.notifications_on_sharp),
                          icon: Icon(Icons.notifications_none_outlined),
                          label:
                              NavigationDestinations.notifications.description,
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
          ),
          KeyedSubtree(
            key: _messagesTabKey,
            child: StreamBuilder<int>(
                stream: locate<ConversationsService>().numUnreadMessagesStream,
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
          ),
          KeyedSubtree(
            key: _youTabKey,
            child: NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_2_outlined),
              label: NavigationDestinations.you.description,
            ),
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
                  key: _fabKey,
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
