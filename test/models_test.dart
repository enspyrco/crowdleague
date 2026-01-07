import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/players/models/player.dart';
import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:crowdleague/venues/models/venue.dart';
import 'package:crowdleague/venues/models/local_venue.dart';
import 'package:crowdleague/venues/models/upload_event.dart';
import 'package:crowdleague/conversations/models/message.dart';
import 'package:crowdleague/conversations/models/conversation.dart';
import 'package:crowdleague/conversations/models/view/conversation_view_model.dart';
import 'package:crowdleague/notifications/models/notification.dart';
import 'package:crowdleague/notifications/models/views/notification_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Player', () {
    test('fromJsonWithId creates Player with all fields', () {
      final json = {
        'name': 'John Doe',
        'picId': 123,
        'pendingCrewRequests': ['req1', 'req2'],
        'crewIds': ['crew1', 'crew2'],
      };

      final player = Player.fromJsonWithId('player123', json);

      expect(player.id, 'player123');
      expect(player.name, 'John Doe');
      expect(player.picId, 123);
      expect(player.pendingCrewRequests, ['req1', 'req2']);
      expect(player.crewIds, ['crew1', 'crew2']);
    });

    test('fromJsonWithId handles null values with defaults', () {
      final json = <String, dynamic>{};

      final player = Player.fromJsonWithId('player123', json);

      expect(player.id, 'player123');
      expect(player.name, '');
      expect(player.picId, 0);
      expect(player.pendingCrewRequests, isEmpty);
      expect(player.crewIds, isEmpty);
    });

    test('toJson returns correct map', () {
      const player = Player(
        id: 'player123',
        name: 'John Doe',
        picId: 123,
        pendingCrewRequests: ['req1'],
        crewIds: ['crew1'],
      );

      final json = player.toJson();

      expect(json['id'], 'player123');
      expect(json['name'], 'John Doe');
      expect(json['picId'], 123);
      expect(json['crewRequests'], ['req1']);
      expect(json['crewIds'], ['crew1']);
    });

    test('toString returns formatted string', () {
      const player = Player(
        id: 'player123',
        name: 'John Doe',
        picId: 123,
        pendingCrewRequests: ['req1'],
        crewIds: ['crew1'],
      );

      expect(player.toString(), contains('player123'));
      expect(player.toString(), contains('John Doe'));
    });

    test('constructProfilePicUrl returns correct URL for small size', () {
      const player = Player(
        id: 'player123',
        name: 'John',
        picId: 456,
        pendingCrewRequests: [],
        crewIds: [],
      );

      final url = player.constructProfilePicUrl(PicSize.small);

      expect(url, contains('profiles/player123/456_small.jpg'));
      expect(url, startsWith('https://storage.googleapis.com/'));
    });

    test('constructProfilePicUrl returns correct URL for medium size', () {
      const player = Player(
        id: 'player123',
        name: 'John',
        picId: 456,
        pendingCrewRequests: [],
        crewIds: [],
      );

      final url = player.constructProfilePicUrl(PicSize.medium);

      expect(url, contains('profiles/player123/456_medium.jpg'));
    });

    test('constructProfilePicUrl returns correct URL for large size', () {
      const player = Player(
        id: 'player123',
        name: 'John',
        picId: 456,
        pendingCrewRequests: [],
        crewIds: [],
      );

      final url = player.constructProfilePicUrl(PicSize.large);

      expect(url, contains('profiles/player123/456_large.jpg'));
    });
  });

  group('EmptyPlayer', () {
    test('has default values', () {
      const emptyPlayer = EmptyPlayer();

      expect(emptyPlayer.id, '');
      expect(emptyPlayer.name, '?');
      expect(emptyPlayer.picId, 0);
      expect(emptyPlayer.pendingCrewRequests, isEmpty);
      expect(emptyPlayer.crewIds, isEmpty);
    });
  });

  group('Venue', () {
    test('fromJson creates Venue with all fields', () {
      final json = {
        'id': 'venue123',
        'size': 2,
        'surface': 1,
        'environment': 1,
        'name': 'Test Court',
        'address': '123 Main St',
        'latitude': 37.7749,
        'longitude': -122.4194,
        'createdBy': 'user123',
      };

      final venue = Venue.fromJson(json);

      expect(venue.id, 'venue123');
      expect(venue.size, 2);
      expect(venue.surface, 1);
      expect(venue.environment, 1);
      expect(venue.name, 'Test Court');
      expect(venue.address, '123 Main St');
      expect(venue.latitude, 37.7749);
      expect(venue.longitude, -122.4194);
      expect(venue.createdBy, 'user123');
    });

    test('constructor creates Venue correctly', () {
      final venue = Venue(
        id: 'venue123',
        size: 1,
        surface: 2,
        environment: 3,
        name: 'My Court',
        address: '456 Oak Ave',
        latitude: 40.7128,
        longitude: -74.0060,
        createdBy: 'user456',
      );

      expect(venue.id, 'venue123');
      expect(venue.size, 1);
      expect(venue.surface, 2);
      expect(venue.environment, 3);
      expect(venue.name, 'My Court');
      expect(venue.address, '456 Oak Ave');
      expect(venue.latitude, 40.7128);
      expect(venue.longitude, -74.0060);
      expect(venue.createdBy, 'user456');
    });
  });

  group('Message', () {
    test('fromJsonWithId creates Message correctly', () {
      final timestamp = Timestamp.fromMillisecondsSinceEpoch(1704067200000);
      final json = {
        'value': 'Hello world',
        'senderId': 'sender123',
        'timestamp': timestamp,
        'readBy': ['user1', 'user2'],
      };

      final message = Message.fromJsonWithId('msg123', json);

      expect(message.id, 'msg123');
      expect(message.value, 'Hello world');
      expect(message.senderId, 'sender123');
      expect(message.timestamp, 1704067200000);
      expect(message.readBy, ['user1', 'user2']);
    });

    test('fromJson creates Message correctly', () {
      final timestamp = Timestamp.fromMillisecondsSinceEpoch(1704067200000);
      final json = {
        'id': 'msg456',
        'value': 'Test message',
        'senderId': 'sender456',
        'timestamp': timestamp,
        'readBy': ['user3'],
      };

      final message = Message.fromJson(json);

      expect(message.id, 'msg456');
      expect(message.value, 'Test message');
      expect(message.senderId, 'sender456');
      expect(message.readBy, ['user3']);
    });

    test('toJson returns correct map', () {
      final message = Message(
        id: 'msg789',
        value: 'Test',
        senderId: 'sender789',
        timestamp: 1704067200000,
        readBy: ['user1'],
      );

      final json = message.toJson();

      expect(json['id'], 'msg789');
      expect(json['value'], 'Test');
      expect(json['senderId'], 'sender789');
      expect(json['timestamp'], 1704067200000);
      expect(json['readBy'], ['user1']);
    });
  });

  group('Conversation', () {
    test('fromJsonWithId creates Conversation correctly', () {
      final json = {
        'participantIds': ['user1', 'user2'],
      };

      final conversation = Conversation.fromJsonWithId('conv123', json);

      expect(conversation.id, 'conv123');
      expect(conversation.participantIds, ['user1', 'user2']);
    });

    test('fromJson creates Conversation correctly', () {
      final json = {
        'id': 'conv456',
        'participantIds': ['user3', 'user4', 'user5'],
      };

      final conversation = Conversation.fromJson(json);

      expect(conversation.id, 'conv456');
      expect(conversation.participantIds, ['user3', 'user4', 'user5']);
    });

    test('toJson returns correct map', () {
      final conversation = Conversation(
        id: 'conv789',
        participantIds: ['userA', 'userB'],
      );

      final json = conversation.toJson();

      expect(json['id'], 'conv789');
      expect(json['participantIds'], ['userA', 'userB']);
    });
  });

  group('Notification', () {
    final timestamp = Timestamp.fromMillisecondsSinceEpoch(1704067200000);

    group('CrewRequestNotification', () {
      test('fromJson creates CrewRequestNotification correctly', () {
        final json = {
          'type': 'crew-request',
          'id': 'notif123',
          'playerId': 'player123',
          'viewed': true,
          'opened': false,
          'waiting': true,
          'requesterId': 'requester123',
          'requesteeId': 'requestee123',
          'timestamp': timestamp,
        };

        final notification = Notification.fromJson(json);

        expect(notification, isA<CrewRequestNotification>());
        final crewRequest = notification as CrewRequestNotification;
        expect(crewRequest.id, 'notif123');
        expect(crewRequest.playerId, 'player123');
        expect(crewRequest.viewed, true);
        expect(crewRequest.opened, false);
        expect(crewRequest.waiting, true);
        expect(crewRequest.requesterId, 'requester123');
        expect(crewRequest.requesteeId, 'requestee123');
      });

      test('fromJsonWithId creates CrewRequestNotification correctly', () {
        final json = {
          'type': 'crew-request',
          'playerId': 'player123',
          'viewed': false,
          'opened': false,
          'waiting': false,
          'requesterId': 'requester123',
          'requesteeId': 'requestee123',
          'timestamp': timestamp,
        };

        final notification = Notification.fromJsonWithId('notif456', json);

        expect(notification, isA<CrewRequestNotification>());
        expect(notification.id, 'notif456');
      });

      test('toJson returns correct map', () {
        final notification = CrewRequestNotification(
          id: 'notif789',
          playerId: 'player789',
          viewed: true,
          opened: true,
          waiting: false,
          requesterId: 'requester789',
          requesteeId: 'requestee789',
          timestamp: timestamp,
        );

        final json = notification.toJson();

        expect(json['id'], 'notif789');
        expect(json['playerId'], 'player789');
        expect(json['type'], 'follow-request');
        expect(json['viewed'], true);
        expect(json['opened'], true);
        expect(json['waiting'], false);
        expect(json['requesterId'], 'requester789');
        expect(json['requesteeId'], 'requestee789');
      });

      test('handles null values with defaults', () {
        final json = {
          'type': 'crew-request',
          'requesterId': 'requester123',
          'requesteeId': 'requestee123',
          'timestamp': timestamp,
        };

        final notification =
            Notification.fromJson(json) as CrewRequestNotification;

        expect(notification.id, '');
        expect(notification.playerId, '');
        expect(notification.viewed, false);
        expect(notification.opened, false);
        expect(notification.waiting, false);
      });
    });

    group('CrewAcceptedNotification', () {
      test('fromJson creates CrewAcceptedNotification correctly', () {
        final json = {
          'type': 'crew-accepted',
          'id': 'notif123',
          'playerId': 'player123',
          'viewed': true,
          'opened': true,
          'waiting': false,
          'requesterId': 'requester123',
          'requesteeId': 'requestee123',
          'timestamp': timestamp,
        };

        final notification = Notification.fromJson(json);

        expect(notification, isA<CrewAcceptedNotification>());
        final crewAccepted = notification as CrewAcceptedNotification;
        expect(crewAccepted.id, 'notif123');
        expect(crewAccepted.requesterId, 'requester123');
        expect(crewAccepted.requesteeId, 'requestee123');
      });

      test('toJson returns correct map', () {
        final notification = CrewAcceptedNotification(
          id: 'notif789',
          playerId: 'player789',
          viewed: false,
          opened: false,
          waiting: true,
          requesterId: 'requester789',
          requesteeId: 'requestee789',
          timestamp: timestamp,
        );

        final json = notification.toJson();

        expect(json['type'], 'crew-accepted');
        expect(json['waiting'], true);
      });
    });

    group('SplitCrewsNotification', () {
      test('fromJson creates SplitCrewsNotification correctly', () {
        final json = {
          'type': 'split-crew',
          'id': 'notif123',
          'playerId': 'player123',
          'viewed': false,
          'opened': false,
          'requesterId': 'requester123',
          'requesteeId': 'requestee123',
          'timestamp': timestamp,
        };

        final notification = Notification.fromJson(json);

        expect(notification, isA<SplitCrewsNotification>());
        final splitCrew = notification as SplitCrewsNotification;
        expect(splitCrew.id, 'notif123');
        expect(splitCrew.requesterId, 'requester123');
        expect(splitCrew.requesteeId, 'requestee123');
      });

      test('toJson returns correct map', () {
        final notification = SplitCrewsNotification(
          id: 'notif789',
          playerId: 'player789',
          viewed: true,
          opened: false,
          requesterId: 'requester789',
          requesteeId: 'requestee789',
          timestamp: timestamp,
        );

        final json = notification.toJson();

        expect(json['type'], 'split-crew');
        expect(json['viewed'], true);
        expect(json['opened'], false);
      });
    });

    test('fromJson throws on unknown type', () {
      final json = {
        'type': 'unknown-type',
        'timestamp': timestamp,
      };

      expect(
        () => Notification.fromJson(json),
        throwsException,
      );
    });
  });

  group('LocalVenue', () {
    test('constructor creates LocalVenue with default values', () {
      final localVenue = LocalVenue();

      expect(localVenue.size, 0);
      expect(localVenue.surface, 0);
      expect(localVenue.environment, 0);
      expect(localVenue.name, '');
      expect(localVenue.address, '');
      expect(localVenue.latitude, 0);
      expect(localVenue.longitude, 0);
      expect(localVenue.createdBy, '');
      expect(localVenue.largePhotoPath, isNull);
      expect(localVenue.smallPhotoPath, isNull);
      expect(localVenue.iconBytes, isNull);
    });

    test('constructor creates LocalVenue with provided values', () {
      final localVenue = LocalVenue(
        size: 2,
        surface: 1,
        environment: 1,
        name: 'Test Court',
        address: '123 Main St',
        latitude: 37.7749,
        longitude: -122.4194,
        createdBy: 'user123',
      );

      expect(localVenue.size, 2);
      expect(localVenue.surface, 1);
      expect(localVenue.environment, 1);
      expect(localVenue.name, 'Test Court');
      expect(localVenue.address, '123 Main St');
      expect(localVenue.latitude, 37.7749);
      expect(localVenue.longitude, -122.4194);
      expect(localVenue.createdBy, 'user123');
    });

    test('toJson returns correct map', () {
      final localVenue = LocalVenue(
        size: 1,
        surface: 2,
        environment: 0,
        name: 'My Venue',
        address: '456 Oak Ave',
        latitude: 40.7128,
        longitude: -74.0060,
        createdBy: 'user456',
      );

      final json = localVenue.toJson();

      expect(json['size'], 1);
      expect(json['surface'], 2);
      expect(json['environment'], 0);
      expect(json['name'], 'My Venue');
      expect(json['address'], '456 Oak Ave');
      expect(json['latitude'], 40.7128);
      expect(json['longitude'], -74.0060);
      expect(json['createdBy'], 'user456');
    });

    test('mutable properties can be updated', () {
      final localVenue = LocalVenue();

      localVenue.name = 'Updated Name';
      localVenue.largePhotoPath = '/path/to/large.jpg';
      localVenue.smallPhotoPath = '/path/to/small.jpg';
      localVenue.iconBytes = Uint8List.fromList([1, 2, 3]);

      expect(localVenue.name, 'Updated Name');
      expect(localVenue.largePhotoPath, '/path/to/large.jpg');
      expect(localVenue.smallPhotoPath, '/path/to/small.jpg');
      expect(localVenue.iconBytes, isNotNull);
      expect(localVenue.iconBytes!.length, 3);
    });
  });

  group('UploadEvent', () {
    test('handles infinite progress', () {
      // When total is 0, transferred/total is infinite
      final event = UploadEvent(transferred: 100, total: 0);
      expect(event.progress, 1.0);
    });

    test('handles NaN progress', () {
      // When both are 0, 0/0 is NaN
      final event = UploadEvent(transferred: 0, total: 0);
      expect(event.progress, 0.0);
    });
  });

  group('ConversationViewModel', () {
    test('constructor creates ConversationViewModel correctly', () {
      final conversation = Conversation(
        id: 'conv123',
        participantIds: ['user1', 'user2'],
      );

      final viewModel = ConversationViewModel(
        conversation: conversation,
        lastMessagePlayerId: 'user2',
        lastMessagePlayerName: 'John Doe',
        lastMessageText: 'Hello there!',
      );

      expect(viewModel.conversation.id, 'conv123');
      expect(viewModel.lastMessagePlayerId, 'user2');
      expect(viewModel.lastMessagePlayerName, 'John Doe');
      expect(viewModel.lastMessageText, 'Hello there!');
    });

    test('fromJson creates ConversationViewModel correctly', () {
      final json = {
        'conversation': {
          'id': 'conv456',
          'participantIds': ['user3', 'user4'],
        },
        'lastMessagePlayerId': 'user4',
        'lastMessagePlayerName': 'Jane Smith',
        'lastMessageText': 'Good morning!',
      };

      final viewModel = ConversationViewModel.fromJson(json);

      expect(viewModel.conversation.id, 'conv456');
      expect(viewModel.conversation.participantIds, ['user3', 'user4']);
      expect(viewModel.lastMessagePlayerId, 'user4');
      expect(viewModel.lastMessagePlayerName, 'Jane Smith');
      expect(viewModel.lastMessageText, 'Good morning!');
    });

    test('toJson returns correct map', () {
      final conversation = Conversation(
        id: 'conv789',
        participantIds: ['user5', 'user6'],
      );

      final viewModel = ConversationViewModel(
        conversation: conversation,
        lastMessagePlayerId: 'user6',
        lastMessagePlayerName: 'Bob',
        lastMessageText: 'Test message',
      );

      final json = viewModel.toJson();

      expect(json['conversation'], isNotNull);
      expect((json['conversation'] as Map)['id'], 'conv789');
      expect(json['lastMessagePlayerId'], 'user6');
    });
  });

  group('NotificationViewModel', () {
    final timestamp = Timestamp.fromMillisecondsSinceEpoch(1704067200000);

    group('CrewRequestNotificationViewModel', () {
      test('creates correctly with all fields', () {
        final notification = CrewRequestNotification(
          id: 'notif123',
          playerId: 'player123',
          viewed: false,
          opened: false,
          waiting: false,
          requesterId: 'requester123',
          requesteeId: 'requestee123',
          timestamp: timestamp,
        );

        final viewModel = CrewRequestNotificationViewModel(
          notification: notification,
          waiting: false,
          requesterName: 'John Doe',
          requesterId: 'requester123',
          requesteeId: 'requestee123',
        );

        expect(viewModel.notification, notification);
        expect(viewModel.waiting, false);
        expect(viewModel.requesterName, 'John Doe');
        expect(viewModel.requesterId, 'requester123');
        expect(viewModel.requesteeId, 'requestee123');
      });
    });

    group('CrewAcceptedNotificationViewModel', () {
      test('creates correctly with all fields', () {
        final notification = CrewAcceptedNotification(
          id: 'notif456',
          playerId: 'player456',
          viewed: true,
          opened: true,
          waiting: false,
          requesterId: 'requester456',
          requesteeId: 'requestee456',
          timestamp: timestamp,
        );

        final viewModel = CrewAcceptedNotificationViewModel(
          notification: notification,
          playerId: 'player456',
          otherName: 'Jane Smith',
          otherPlayerId: 'other456',
        );

        expect(viewModel.notification, notification);
        expect(viewModel.playerId, 'player456');
        expect(viewModel.otherName, 'Jane Smith');
        expect(viewModel.otherPlayerId, 'other456');
      });
    });

    group('SplitCrewsNotificationViewModel', () {
      test('creates correctly with all fields', () {
        final notification = SplitCrewsNotification(
          id: 'notif789',
          playerId: 'player789',
          viewed: false,
          opened: false,
          requesterId: 'requester789',
          requesteeId: 'requestee789',
          timestamp: timestamp,
        );

        final viewModel = SplitCrewsNotificationViewModel(
          notification: notification,
          playerName: 'Bob Wilson',
          playerId: 'player789',
        );

        expect(viewModel.notification, notification);
        expect(viewModel.playerName, 'Bob Wilson');
        expect(viewModel.playerId, 'player789');
      });
    });
  });
}
