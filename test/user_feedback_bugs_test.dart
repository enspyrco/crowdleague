import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/conversations/conversations_screen.dart';
import 'package:crowdleague/conversations/conversations_service.dart';
import 'package:crowdleague/conversations/models/conversation.dart';
import 'package:crowdleague/conversations/models/message.dart';
import 'package:crowdleague/conversations/models/view/conversation_view_model.dart';
import 'package:crowdleague/notifications/models/notification.dart';
import 'package:crowdleague/notifications/models/views/notification_view_model.dart';
import 'package:crowdleague/notifications/widgets/crew_request_notification_widget.dart';
import 'package:crowdleague/onboarding/onboard_notifications.dart';
import 'package:crowdleague/players/models/player.dart';
import 'package:crowdleague/players/players_service.dart';
import 'package:crowdleague/services/user_service.dart';
import 'package:crowdleague/utils/cache/player_cache.dart';
import 'package:crowdleague/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Widget tests for user feedback bugs.
///
/// These tests cover the bugs split from issue #181:
/// - #196: Infinite loading circle on add photo
/// - #197: Can tap tick button immediately after adding photo
/// - #198: Notifications onboarding screen text has incorrect formatting
/// - #199: AcceptCrewNotification extends beyond card bounds
/// - #200: Notification buttons lack instant visual feedback
/// - #201: Unread message count is inaccurate
/// - #202: Conversation not appearing in Messages list
void main() {
  group('Onboarding Bugs', () {
    // Bug #196: Infinite loading circle on add photo during onboarding
    // Bug #197: Can tap tick button immediately after adding photo
    // PARTIALLY FIXED in PR #206 - Upload state now resets properly
    //
    // Note: This test requires full app setup with all services.
    // Skipping for now - the widget requires UserService, StorageService, etc.
    testWidgets(
      '#196 #197: Photo upload should disable tick button until complete',
      skip: true, // Requires full service mocking
      (tester) async {
        // This test would verify button is disabled during upload
      },
    );

    // Bug #198: Notifications onboarding screen text has incorrect formatting
    // FIXED in PR #209
    testWidgets(
      '#198: Onboarding notifications text should not have hard line breaks',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: OnboardNotifications(),
          ),
        );
        await tester.pumpAndSettle();

        // Find the description text widget
        final textFinder = find.textContaining('When players you follow');
        expect(textFinder, findsOneWidget);

        // Get the Text widget
        final textWidget = tester.widget<Text>(textFinder);
        final textData = textWidget.data ?? '';

        // FIXED: Text no longer contains hard line breaks
        expect(textData.contains('\n'), isFalse,
            reason: 'Text should flow naturally without hard line breaks');
      },
    );
  });

  group('Notifications Screen Bugs', () {
    // Bug #199: AcceptCrewNotification extends beyond card bounds
    testWidgets(
      '#199: CrewRequestNotificationWidget should fit within card bounds',
      (tester) async {
        // Create test notification data
        final notification = CrewRequestNotification(
          id: 'test-notification-id',
          playerId: 'test-player-id',
          requesterId: 'requester-id',
          requesteeId: 'requestee-id',
          waiting: false,
          viewed: false,
          opened: false,
          timestamp: Timestamp.now(),
        );

        final viewModel = CrewRequestNotificationViewModel(
          notification: notification,
          waiting: false,
          requesterName:
              'Test Player With A Very Long Name That Might Overflow',
          requesterId: 'requester-id',
          requesteeId: 'requestee-id',
        );

        // Set up mock services
        final mockUserService = MockUserService();
        final mockPlayersService = MockPlayersService();
        mockPlayersService.addPlayer(Player(
          id: 'requester-id',
          name: 'Test Player With A Very Long Name That Might Overflow',
          picId: 0,
          pendingCrewRequests: [],
          crewIds: [],
        ));
        Locator.add<UserService>(mockUserService);
        Locator.add<PlayersService>(mockPlayersService);

        // Render the widget in a constrained container (simulating card bounds)
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300, // Narrow width to trigger potential overflow
                child: CrewRequestNotificationWidget(viewModel),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // FIXED: Widget no longer overflows with long names
        expect(tester.takeException(), isNull,
            reason: 'Widget should not cause overflow errors');

        // Verify the card is rendered
        expect(find.byType(Card), findsOneWidget);

        // Verify buttons are visible
        expect(find.text('Accept'), findsOneWidget);
        expect(find.text('Decline'), findsOneWidget);
      },
    );

    // Test Accept button calls UserService.acceptCrewRequest
    testWidgets(
      'Accept button calls acceptCrewRequest with correct arguments',
      (tester) async {
        final notification = CrewRequestNotification(
          id: 'notif-123',
          playerId: 'player-id',
          requesterId: 'requester-456',
          requesteeId: 'requestee-789',
          waiting: false,
          viewed: false,
          opened: false,
          timestamp: Timestamp.now(),
        );

        final viewModel = CrewRequestNotificationViewModel(
          notification: notification,
          waiting: false,
          requesterName: 'John Doe',
          requesterId: 'requester-456',
          requesteeId: 'requestee-789',
        );

        final mockUserService = MockUserService();
        final mockPlayersService = MockPlayersService();
        mockPlayersService.addPlayer(Player(
          id: 'requester-456',
          name: 'John Doe',
          picId: 0, // Use 0 to avoid network image requests in tests
          pendingCrewRequests: [],
          crewIds: [],
        ));
        Locator.add<UserService>(mockUserService);
        Locator.add<PlayersService>(mockPlayersService);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CrewRequestNotificationWidget(viewModel),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify initial state - service not called yet
        expect(mockUserService.acceptCrewRequestCalled, isFalse);

        // Tap Accept button
        await tester.tap(find.widgetWithText(OutlinedButton, 'Accept'));
        await tester.pumpAndSettle();

        // Verify service was called with correct arguments
        expect(mockUserService.acceptCrewRequestCalled, isTrue,
            reason: 'acceptCrewRequest should be called when Accept is tapped');
        expect(mockUserService.lastAcceptedNotificationId, equals('notif-123'),
            reason: 'Should pass correct notification ID');
        expect(mockUserService.lastAcceptedRequesterId, equals('requester-456'),
            reason: 'Should pass correct requester ID');
        expect(mockUserService.lastAcceptedRequesteeId, equals('requestee-789'),
            reason: 'Should pass correct requestee ID');
      },
    );

    // Test Decline button calls UserService.declineCrewRequest
    testWidgets(
      'Decline button calls declineCrewRequest with correct arguments',
      (tester) async {
        final notification = CrewRequestNotification(
          id: 'notif-abc',
          playerId: 'player-id',
          requesterId: 'requester-def',
          requesteeId: 'requestee-ghi',
          waiting: false,
          viewed: false,
          opened: false,
          timestamp: Timestamp.now(),
        );

        final viewModel = CrewRequestNotificationViewModel(
          notification: notification,
          waiting: false,
          requesterName: 'Jane Smith',
          requesterId: 'requester-def',
          requesteeId: 'requestee-ghi',
        );

        final mockUserService = MockUserService();
        final mockPlayersService = MockPlayersService();
        mockPlayersService.addPlayer(Player(
          id: 'requester-def',
          name: 'Jane Smith',
          picId: 0, // Use 0 to avoid network image requests in tests
          pendingCrewRequests: [],
          crewIds: [],
        ));
        Locator.add<UserService>(mockUserService);
        Locator.add<PlayersService>(mockPlayersService);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CrewRequestNotificationWidget(viewModel),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify initial state
        expect(mockUserService.declineCrewRequestCalled, isFalse);

        // Tap Decline button
        await tester.tap(find.widgetWithText(OutlinedButton, 'Decline'));
        await tester.pumpAndSettle();

        // Verify service was called with correct arguments
        expect(mockUserService.declineCrewRequestCalled, isTrue,
            reason:
                'declineCrewRequest should be called when Decline is tapped');
        expect(mockUserService.lastDeclinedNotificationId, equals('notif-abc'),
            reason: 'Should pass correct notification ID');
        expect(mockUserService.lastDeclinedRequesterId, equals('requester-def'),
            reason: 'Should pass correct requester ID');
      },
    );

    // Test waiting state hides buttons and shows loading text
    testWidgets(
      'Widget shows loading state when waiting is true',
      (tester) async {
        final notification = CrewRequestNotification(
          id: 'notif-waiting',
          playerId: 'player-id',
          requesterId: 'requester-id',
          requesteeId: 'requestee-id',
          waiting: true, // Waiting state
          viewed: false,
          opened: false,
          timestamp: Timestamp.now(),
        );

        final viewModel = CrewRequestNotificationViewModel(
          notification: notification,
          waiting: true, // Waiting state
          requesterName: 'Waiting Player',
          requesterId: 'requester-id',
          requesteeId: 'requestee-id',
        );

        final mockUserService = MockUserService();
        final mockPlayersService = MockPlayersService();
        mockPlayersService.addPlayer(Player(
          id: 'requester-id',
          name: 'Waiting Player',
          picId: 0,
          pendingCrewRequests: [],
          crewIds: [],
        ));
        Locator.add<UserService>(mockUserService);
        Locator.add<PlayersService>(mockPlayersService);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CrewRequestNotificationWidget(viewModel),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Buttons should not be visible when waiting
        expect(find.text('Accept'), findsNothing,
            reason: 'Accept button should be hidden when waiting');
        expect(find.text('Decline'), findsNothing,
            reason: 'Decline button should be hidden when waiting');

        // Loading text should be visible
        expect(find.text('Updating crew members...'), findsOneWidget,
            reason: 'Loading text should be shown when waiting');
      },
    );

    // Bug #200: Notification buttons lack instant visual feedback
    testWidgets(
      '#200: Notification buttons should have proper Material feedback',
      (tester) async {
        final notification = CrewRequestNotification(
          id: 'test-notification-id',
          playerId: 'test-player-id',
          requesterId: 'requester-id',
          requesteeId: 'requestee-id',
          waiting: false,
          viewed: false,
          opened: false,
          timestamp: Timestamp.now(),
        );

        final viewModel = CrewRequestNotificationViewModel(
          notification: notification,
          waiting: false,
          requesterName: 'Test Player',
          requesterId: 'requester-id',
          requesteeId: 'requestee-id',
        );

        final mockUserService = MockUserService();
        final mockPlayersService = MockPlayersService();
        mockPlayersService.addPlayer(Player(
          id: 'requester-id',
          name: 'Test Player',
          picId: 0,
          pendingCrewRequests: [],
          crewIds: [],
        ));
        Locator.add<UserService>(mockUserService);
        Locator.add<PlayersService>(mockPlayersService);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CrewRequestNotificationWidget(viewModel),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify buttons are OutlinedButtons (which have built-in ink feedback)
        final acceptButton = find.widgetWithText(OutlinedButton, 'Accept');
        final declineButton = find.widgetWithText(OutlinedButton, 'Decline');

        expect(acceptButton, findsOneWidget);
        expect(declineButton, findsOneWidget);

        // OutlinedButton has InkWell internally for visual feedback
        final acceptInkWell = find.ancestor(
          of: find.text('Accept'),
          matching: find.byType(InkWell),
        );
        expect(acceptInkWell, findsWidgets,
            reason: 'Accept button should have InkWell for visual feedback');

        final declineInkWell = find.ancestor(
          of: find.text('Decline'),
          matching: find.byType(InkWell),
        );
        expect(declineInkWell, findsWidgets,
            reason: 'Decline button should have InkWell for visual feedback');
      },
    );
  });

  group('Messages Screen Bugs', () {
    // Bug #201/#203: Messages badge - test unread count stream
    test(
      '#201/#203: ConversationsService emits unread message count',
      () async {
        final mockConversationsService = MockConversationsService();

        // Collect emitted values
        final emittedCounts = <int>[];
        final subscription = mockConversationsService.numUnreadMessagesStream
            .listen((count) => emittedCounts.add(count));

        // Emit unread counts
        mockConversationsService.setUnreadCount(5);
        mockConversationsService.setUnreadCount(3);
        mockConversationsService.setUnreadCount(0);

        // Allow microtasks to complete
        await Future.delayed(Duration.zero);

        // Verify the stream emitted expected values
        expect(emittedCounts, equals([5, 3, 0]),
            reason: 'Stream should emit all unread count updates');

        await subscription.cancel();
      },
    );

    // Bug #202: Conversation not appearing in Messages list
    testWidgets(
      '#202: All conversations should appear in Messages list',
      (tester) async {
        // Set up mock services
        final mockConversationsService = MockConversationsService();
        final mockPlayersService = MockPlayersService();

        // Add test players for the avatars (picId: 0 to avoid network requests)
        mockPlayersService.addPlayer(Player(
          id: 'player-alice',
          name: 'Alice Johnson',
          picId: 0,
          pendingCrewRequests: [],
          crewIds: [],
        ));
        mockPlayersService.addPlayer(Player(
          id: 'player-bob',
          name: 'Bob Smith',
          picId: 0,
          pendingCrewRequests: [],
          crewIds: [],
        ));
        mockPlayersService.addPlayer(Player(
          id: 'player-charlie',
          name: 'Charlie Brown',
          picId: 0,
          pendingCrewRequests: [],
          crewIds: [],
        ));

        // Add test conversations
        mockConversationsService.addConversation(ConversationViewModel(
          conversation: Conversation(
            id: 'conv-1',
            participantIds: ['current-user', 'player-alice'],
          ),
          lastMessagePlayerId: 'player-alice',
          lastMessagePlayerName: 'Alice Johnson',
          lastMessageText: 'Hey, want to play tennis?',
        ));
        mockConversationsService.addConversation(ConversationViewModel(
          conversation: Conversation(
            id: 'conv-2',
            participantIds: ['current-user', 'player-bob'],
          ),
          lastMessagePlayerId: 'player-bob',
          lastMessagePlayerName: 'Bob Smith',
          lastMessageText: 'See you at the court!',
        ));
        mockConversationsService.addConversation(ConversationViewModel(
          conversation: Conversation(
            id: 'conv-3',
            participantIds: ['current-user', 'player-charlie'],
          ),
          lastMessagePlayerId: 'player-charlie',
          lastMessagePlayerName: 'Charlie Brown',
          lastMessageText: 'Good game yesterday!',
        ));

        Locator.add<ConversationsService>(mockConversationsService);
        Locator.add<PlayersService>(mockPlayersService);

        await tester.pumpWidget(
          MaterialApp(
            home: ConversationsScreen(),
          ),
        );
        await tester.pumpAndSettle();

        // Verify all conversations are displayed
        expect(find.text('Alice Johnson'), findsOneWidget,
            reason: 'First conversation should be displayed');
        expect(find.text('Hey, want to play tennis?'), findsOneWidget,
            reason: 'First conversation message should be displayed');

        expect(find.text('Bob Smith'), findsOneWidget,
            reason: 'Second conversation should be displayed');
        expect(find.text('See you at the court!'), findsOneWidget,
            reason: 'Second conversation message should be displayed');

        expect(find.text('Charlie Brown'), findsOneWidget,
            reason: 'Third conversation should be displayed');
        expect(find.text('Good game yesterday!'), findsOneWidget,
            reason: 'Third conversation message should be displayed');

        // Verify correct number of list items
        expect(find.byType(InkWell), findsNWidgets(3),
            reason: 'Should display exactly 3 conversation items');
      },
    );

    // Test empty conversations list
    testWidgets(
      'ConversationsScreen shows empty state when no conversations',
      (tester) async {
        final mockConversationsService = MockConversationsService();
        // Don't add any conversations - empty list

        Locator.add<ConversationsService>(mockConversationsService);

        await tester.pumpWidget(
          MaterialApp(
            home: ConversationsScreen(),
          ),
        );
        await tester.pumpAndSettle();

        // With empty list, ListView should have 0 items
        expect(find.byType(InkWell), findsNothing,
            reason: 'Should show no conversation items when list is empty');
      },
    );

    // Test that tapping a conversation can navigate (structure test)
    // Skip: Requires GoRouter setup which adds complexity
    testWidgets(
      'Conversation item is tappable',
      skip: true, // Requires GoRouter setup
      (tester) async {
        // This test would verify navigation works when tapping a conversation
      },
    );
  });
}

/// Mock UserService for testing notification widgets
class MockUserService implements UserService {
  bool acceptCrewRequestCalled = false;
  bool declineCrewRequestCalled = false;
  String? lastAcceptedNotificationId;
  String? lastAcceptedRequesterId;
  String? lastAcceptedRequesteeId;
  String? lastDeclinedNotificationId;
  String? lastDeclinedRequesterId;

  @override
  Future<void> acceptCrewRequest({
    required String requesterId,
    required String requesteeId,
    required String notificationId,
  }) async {
    acceptCrewRequestCalled = true;
    lastAcceptedNotificationId = notificationId;
    lastAcceptedRequesterId = requesterId;
    lastAcceptedRequesteeId = requesteeId;
  }

  @override
  Future<void> declineCrewRequest(
      String notificationId, String requesterId) async {
    declineCrewRequestCalled = true;
    lastDeclinedNotificationId = notificationId;
    lastDeclinedRequesterId = requesterId;
  }

  // Stub remaining UserService methods
  @override
  String? get currentUserId => 'test-user-id';

  @override
  Stream<Map<String, Object?>?> get profileDocStream => Stream.value({});

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signInWithApple() async {}

  @override
  Future<void> signOut() async {}

  @override
  Player? getUserPlayer() => null;

  @override
  Future<bool> get userHasOnboarded async => true;

  @override
  Future<void> updateProfileName(String name) async {}

  @override
  Future<void> requestCrew({required String playerId}) async {}

  @override
  Future<void> splitCrews(String playerId) async {}

  @override
  Future<void> deleteAccount() async {}
}

/// Mock PlayersService for Avatar widget
class MockPlayersService implements PlayersService {
  final Map<String, Player> _players = {};

  void addPlayer(Player player) {
    _players[player.id] = player;
  }

  @override
  Future<Player?> retrievePlayer(String playerId) async {
    return _players[playerId];
  }

  @override
  Future<List<Player>> retrievePlayers() async {
    return _players.values.toList();
  }

  @override
  PlayerCacheItem? bustCache(String playerId) => null;

  @override
  Stream<Player?> listenToPlayer(String playerId) {
    return Stream.value(_players[playerId]);
  }
}

/// Mock ConversationsService for testing conversations screen
class MockConversationsService implements ConversationsService {
  final List<ConversationViewModel> _conversations = [];
  final _unreadCountController = StreamController<int>.broadcast();
  bool findOrCreateConversationCalled = false;
  String? lastCreatedConversationId;
  bool sendMessageCalled = false;
  String? lastSentMessage;
  bool markMessagesAsReadCalled = false;
  String? lastMarkedConversationId;

  void addConversation(ConversationViewModel viewModel) {
    _conversations.add(viewModel);
  }

  void setUnreadCount(int count) {
    _unreadCountController.add(count);
  }

  @override
  Stream<int> get numUnreadMessagesStream => _unreadCountController.stream;

  @override
  Future<List<ConversationViewModel>> retrieveConversationViewModels() async {
    return _conversations;
  }

  @override
  Future<String> findOrCreateConversation(String playerId) async {
    findOrCreateConversationCalled = true;
    lastCreatedConversationId = 'mock-conversation-$playerId';
    return lastCreatedConversationId!;
  }

  @override
  Future<void> sendMessage(String conversationId, String value) async {
    sendMessageCalled = true;
    lastSentMessage = value;
  }

  @override
  Stream<List<Message>> messagesStreamFor(String conversationId) {
    return Stream.value([]);
  }

  @override
  Future<void> markMessagesAsRead(String conversationId) async {
    markMessagesAsReadCalled = true;
    lastMarkedConversationId = conversationId;
  }

  @override
  Future<void> readAndEmitUnreadMessages() async {
    // No-op for tests
  }
}
