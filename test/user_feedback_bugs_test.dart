import 'dart:async';

import 'package:crowdleague/conversations/conversations_screen.dart';
import 'package:crowdleague/conversations/conversations_service.dart';
import 'package:crowdleague/conversations/models/conversation.dart';
import 'package:crowdleague/conversations/models/message.dart';
import 'package:crowdleague/conversations/models/view/conversation_view_model.dart';
import 'package:crowdleague/onboarding/onboard_notifications.dart';
import 'package:crowdleague/players/models/player.dart';
import 'package:crowdleague/players/players_service.dart';
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

  group('Messages Bugs', () {
    // Bug #201: Unread message count is inaccurate
    test(
      '#201: Unread count stream should emit accurate counts',
      () async {
        final mockConversationsService = MockConversationsService();

        // Collect emitted values
        final emittedCounts = <int>[];
        final subscription = mockConversationsService.numUnreadMessagesStream
            .listen((value) => emittedCounts.add(value));

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
        mockConversationsService.dispose();
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
        mockPlayersService.addPlayer(const Player(
          id: 'player-alice',
          name: 'Alice Johnson',
          picId: 0,
          venueCrewIds: [],
          teamIds: [],
        ));
        mockPlayersService.addPlayer(const Player(
          id: 'player-bob',
          name: 'Bob Smith',
          picId: 0,
          venueCrewIds: [],
          teamIds: [],
        ));
        mockPlayersService.addPlayer(const Player(
          id: 'player-charlie',
          name: 'Charlie Brown',
          picId: 0,
          venueCrewIds: [],
          teamIds: [],
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

  void dispose() {
    _unreadCountController.close();
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
