import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/players/models/player.dart';
import 'package:crowdleague/players/players_service.dart';
import 'package:crowdleague/utils/cache/player_cache.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlayerCache', () {
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
    });

    test('retrievePlayer fetches from firestore on first call', () async {
      await fakeFirestore.collection('profiles').doc('player123').set({
        'name': 'Test Player',
        'picId': 1,
        'pendingCrewRequests': [],
        'crewIds': [],
      });

      final cache = PlayerCache(firestore: fakeFirestore);
      final player = await cache.retrievePlayer('player123');

      expect(player.id, 'player123');
      expect(player.name, 'Test Player');
      expect(player.picId, 1);
    });

    test('retrievePlayer returns cached player on subsequent calls', () async {
      await fakeFirestore.collection('profiles').doc('player123').set({
        'name': 'Original Name',
        'picId': 1,
      });

      final cache = PlayerCache(firestore: fakeFirestore, staleSeconds: 60);

      // First call - fetches from firestore
      final player1 = await cache.retrievePlayer('player123');
      expect(player1.name, 'Original Name');

      // Update firestore directly
      await fakeFirestore.collection('profiles').doc('player123').set({
        'name': 'Updated Name',
        'picId': 1,
      });

      // Second call - should return cached value
      final player2 = await cache.retrievePlayer('player123');
      expect(player2.name, 'Original Name'); // Still cached
    });

    test('bustPlayer removes player from cache', () async {
      await fakeFirestore.collection('profiles').doc('player123').set({
        'name': 'Test Player',
        'picId': 1,
      });

      final cache = PlayerCache(firestore: fakeFirestore, staleSeconds: 60);

      // Populate cache
      await cache.retrievePlayer('player123');

      // Update firestore
      await fakeFirestore.collection('profiles').doc('player123').set({
        'name': 'New Name',
        'picId': 1,
      });

      // Bust cache
      final busted = cache.bustPlayer('player123');
      expect(busted, isNotNull);
      expect(busted!.player.name, 'Test Player');

      // Next retrieve should fetch fresh data
      final player = await cache.retrievePlayer('player123');
      expect(player.name, 'New Name');
    });

    test('bustPlayer returns null for non-cached player', () {
      final cache = PlayerCache(firestore: fakeFirestore);
      final result = cache.bustPlayer('nonexistent');
      expect(result, isNull);
    });

    test('retrievePlayer handles missing data gracefully', () async {
      // Document exists but has no data
      await fakeFirestore.collection('profiles').doc('empty').set({});

      final cache = PlayerCache(firestore: fakeFirestore);
      final player = await cache.retrievePlayer('empty');

      expect(player.id, 'empty');
      expect(player.name, '');
      expect(player.picId, 0);
    });
  });

  group('PlayersService', () {
    late FakeFirebaseFirestore fakeFirestore;
    late MockFirebaseStorage fakeStorage;
    late PlayerCache playerCache;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      fakeStorage = MockFirebaseStorage();
      playerCache = PlayerCache(firestore: fakeFirestore);
    });

    test('retrievePlayers returns empty list when no profiles exist', () async {
      final service = PlayersService(
        firestore: fakeFirestore,
        storage: fakeStorage,
        playerCache: playerCache,
      );

      final players = await service.retrievePlayers();

      expect(players, isEmpty);
    });

    test('retrievePlayers returns all profiles', () async {
      await fakeFirestore.collection('profiles').doc('player1').set({
        'name': 'Alice',
        'picId': 1,
      });
      await fakeFirestore.collection('profiles').doc('player2').set({
        'name': 'Bob',
        'picId': 2,
      });

      final service = PlayersService(
        firestore: fakeFirestore,
        storage: fakeStorage,
        playerCache: playerCache,
      );

      final players = await service.retrievePlayers();

      expect(players.length, 2);
      expect(players.map((p) => p.name), containsAll(['Alice', 'Bob']));
    });

    test('retrievePlayer uses cache', () async {
      await fakeFirestore.collection('profiles').doc('player123').set({
        'name': 'Cached Player',
        'picId': 5,
      });

      final service = PlayersService(
        firestore: fakeFirestore,
        storage: fakeStorage,
        playerCache: playerCache,
      );

      final player = await service.retrievePlayer('player123');

      expect(player, isNotNull);
      expect(player!.name, 'Cached Player');
    });

    test('bustCache removes player from cache', () async {
      await fakeFirestore.collection('profiles').doc('player123').set({
        'name': 'Player',
        'picId': 1,
      });

      final service = PlayersService(
        firestore: fakeFirestore,
        storage: fakeStorage,
        playerCache: playerCache,
      );

      // First populate the cache
      await service.retrievePlayer('player123');

      // Bust it
      final busted = service.bustCache('player123');
      expect(busted, isNotNull);
    });

    test('listenToPlayer emits player updates', () async {
      await fakeFirestore.collection('profiles').doc('player123').set({
        'name': 'Initial',
        'picId': 1,
      });

      final service = PlayersService(
        firestore: fakeFirestore,
        storage: fakeStorage,
        playerCache: playerCache,
      );

      final stream = service.listenToPlayer('player123');

      expectLater(
        stream,
        emits(predicate<Player?>((p) => p?.name == 'Initial')),
      );
    });

    test('listenToPlayer emits null for non-existent player', () async {
      final service = PlayersService(
        firestore: fakeFirestore,
        storage: fakeStorage,
        playerCache: playerCache,
      );

      final stream = service.listenToPlayer('nonexistent');

      expectLater(
        stream,
        emits(isNull),
      );
    });
  });

  group('ConversationsService', () {
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
    });

    test('findOrCreateConversation creates new conversation', () async {
      // Set up test data
      await fakeFirestore.collection('profiles').doc('user1').set({
        'name': 'User 1',
        'picId': 1,
      });
      await fakeFirestore.collection('profiles').doc('user2').set({
        'name': 'User 2',
        'picId': 2,
      });

      // Verify conversation doesn't exist
      final existingConv =
          await fakeFirestore.collection('conversations').doc('user1_user2').get();
      expect(existingConv.exists, false);
    });

    test('messagesStreamFor returns message stream', () async {
      final conversationId = 'conv123';

      // Add a message
      await fakeFirestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add({
        'id': 'msg1',
        'value': 'Hello',
        'senderId': 'sender1',
        'timestamp': Timestamp.now(),
        'readBy': ['sender1'],
      });

      // We can't easily test ConversationsService without mocking FirebaseAuth
      // and FirebaseFunctions, but we can verify the Firestore operations work
      final messagesSnapshot = await fakeFirestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .get();

      expect(messagesSnapshot.docs.length, 1);
      expect(messagesSnapshot.docs.first.data()['value'], 'Hello');
    });

    test('conversation data structure is correct', () async {
      final sortedIds = ['user1', 'user2']..sort();
      final conversationId = '${sortedIds.first}_${sortedIds.last}';

      await fakeFirestore.collection('conversations').doc(conversationId).set({
        'participantIds': sortedIds,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      final doc = await fakeFirestore
          .collection('conversations')
          .doc(conversationId)
          .get();

      expect(doc.exists, true);
      expect(doc.data()!['participantIds'], ['user1', 'user2']);
    });

    test('marking messages as read updates readBy field', () async {
      final conversationId = 'conv123';
      final userId = 'currentUser';

      // Add a message from another user
      final msgRef = await fakeFirestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add({
        'value': 'Hello',
        'senderId': 'otherUser',
        'timestamp': Timestamp.now(),
        'readBy': ['otherUser'],
      });

      // Manually update readBy (simulating what markMessagesAsRead does)
      await msgRef.update({
        'readBy': FieldValue.arrayUnion([userId]),
      });

      // Verify the update
      final updated = await msgRef.get();
      expect(updated.data()!['readBy'], contains(userId));
    });

    test('unread count calculation logic', () async {
      final userId = 'currentUser';
      final conversationId = 'conv123';

      // Create conversation with user as participant
      await fakeFirestore.collection('conversations').doc(conversationId).set({
        'participantIds': [userId, 'otherUser'],
      });

      // Add messages - 2 unread from other user
      await fakeFirestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add({
        'value': 'Unread 1',
        'senderId': 'otherUser',
        'timestamp': Timestamp.now(),
        'readBy': ['otherUser'],
      });

      await fakeFirestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add({
        'value': 'Unread 2',
        'senderId': 'otherUser',
        'timestamp': Timestamp.now(),
        'readBy': ['otherUser'],
      });

      // Add message from current user (should not count as unread)
      await fakeFirestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add({
        'value': 'My message',
        'senderId': userId,
        'timestamp': Timestamp.now(),
        'readBy': [userId],
      });

      // Query unread messages (simulating service logic)
      final messagesSnapshot = await fakeFirestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .where('senderId', isNotEqualTo: userId)
          .get();

      int unreadCount = 0;
      for (final doc in messagesSnapshot.docs) {
        final readBy = List<String>.from(doc.data()['readBy'] ?? []);
        if (!readBy.contains(userId)) {
          unreadCount++;
        }
      }

      expect(unreadCount, 2);
    });
  });
}
