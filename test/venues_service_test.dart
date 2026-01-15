import 'package:cloud_functions/cloud_functions.dart';
import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:crowdleague/venues/models/venue.dart';
import 'package:crowdleague/venues/venues_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VenuesService', () {
    late FakeFirebaseFirestore fakeFirestore;
    late MockFirebaseStorage fakeStorage;
    late MockFirebaseAuth mockAuth;
    late MockFirebaseFunctions mockFunctions;
    late VenuesService service;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      fakeStorage = MockFirebaseStorage();
      mockAuth = MockFirebaseAuth();
      mockFunctions = MockFirebaseFunctions();
      service = VenuesService(
        firestore: fakeFirestore,
        storage: fakeStorage,
        cloudFunctions: mockFunctions,
        auth: mockAuth,
      );
    });

    group('createNewVenue', () {
      test('creates venue and returns id', () async {
        final data = {
          'name': 'Test Court',
          'address': '123 Test St',
          'latitude': 37.7749,
          'longitude': -122.4194,
          'size': 1,
          'surface': 1,
          'environment': 1,
          'createdBy': 'user123',
          'photoCount': 2,
        };

        final id = await service.createNewVenue(data);

        expect(id, isNotEmpty);

        // Verify venue was created in Firestore
        final doc = await fakeFirestore.collection('venues').doc(id).get();
        expect(doc.exists, true);
        expect(doc.data()!['name'], 'Test Court');
        expect(doc.data()!['photoCount'], 2);
      });
    });

    group('getPhotoUrl', () {
      test('returns correct URL for small size at index 0', () {
        final url =
            service.getPhotoUrl('venue123', PicSize.small, photoIndex: 0);

        expect(url, contains('venue123_0_small.jpg'));
        expect(url, contains('crowdleague-venues'));
      });

      test('returns correct URL for medium size at index 1', () {
        final url =
            service.getPhotoUrl('venue123', PicSize.medium, photoIndex: 1);

        expect(url, contains('venue123_1_medium.jpg'));
      });

      test('returns correct URL for large size at index 2', () {
        final url =
            service.getPhotoUrl('venue123', PicSize.large, photoIndex: 2);

        expect(url, contains('venue123_2_large.jpg'));
      });

      test('defaults to index 0 when not specified', () {
        final url = service.getPhotoUrl('venue123', PicSize.small);

        expect(url, contains('venue123_0_small.jpg'));
      });
    });

    group('getAllPhotoUrls', () {
      test('returns correct number of URLs', () {
        final urls = service.getAllPhotoUrls('venue123', 3, PicSize.medium);

        expect(urls.length, 3);
      });

      test('returns URLs with correct indices', () {
        final urls = service.getAllPhotoUrls('venue123', 3, PicSize.medium);

        expect(urls[0], contains('venue123_0_medium.jpg'));
        expect(urls[1], contains('venue123_1_medium.jpg'));
        expect(urls[2], contains('venue123_2_medium.jpg'));
      });

      test('returns empty list for zero photos', () {
        final urls = service.getAllPhotoUrls('venue123', 0, PicSize.small);

        expect(urls, isEmpty);
      });

      test('returns correct URLs for max photos (5)', () {
        final urls = service.getAllPhotoUrls('venue123', 5, PicSize.large);

        expect(urls.length, 5);
        expect(urls[4], contains('venue123_4_large.jpg'));
      });
    });

    group('retrieveVenue', () {
      test('returns venue when it exists', () async {
        await fakeFirestore.collection('venues').doc('venue123').set({
          'name': 'Test Court',
          'address': '123 Test St',
          'latitude': 37.7749,
          'longitude': -122.4194,
          'size': 2,
          'surface': 1,
          'environment': 1,
          'createdBy': 'user123',
          'photoCount': 3,
        });

        final venue = await service.retrieveVenue('venue123');

        expect(venue, isNotNull);
        expect(venue!.id, 'venue123');
        expect(venue.name, 'Test Court');
        expect(venue.photoCount, 3);
      });

      test('returns null when venue does not exist', () async {
        final venue = await service.retrieveVenue('nonexistent');

        expect(venue, isNull);
      });

      test('defaults photoCount to 1 for legacy venues', () async {
        // Legacy venue without photoCount field
        await fakeFirestore.collection('venues').doc('legacy').set({
          'name': 'Legacy Court',
          'address': '456 Old St',
          'latitude': 37.0,
          'longitude': -122.0,
          'size': 1,
          'surface': 1,
          'environment': 1,
          'createdBy': 'user456',
          // No photoCount field
        });

        final venue = await service.retrieveVenue('legacy');

        expect(venue, isNotNull);
        expect(venue!.photoCount, 1); // Should default to 1
      });
    });

    group('retrieveVenues', () {
      test('returns empty list when no venues exist', () async {
        final venues = await service.retrieveVenues();

        expect(venues, isEmpty);
      });

      test('returns all venues', () async {
        await fakeFirestore.collection('venues').doc('venue1').set({
          'name': 'Court A',
          'address': '111 A St',
          'latitude': 37.0,
          'longitude': -122.0,
          'size': 1,
          'surface': 1,
          'environment': 1,
          'createdBy': 'user1',
          'photoCount': 1,
        });
        await fakeFirestore.collection('venues').doc('venue2').set({
          'name': 'Court B',
          'address': '222 B St',
          'latitude': 38.0,
          'longitude': -123.0,
          'size': 2,
          'surface': 2,
          'environment': 2,
          'createdBy': 'user2',
          'photoCount': 4,
        });

        final venues = await service.retrieveVenues();

        expect(venues.length, 2);
        expect(venues.map((v) => v.name), containsAll(['Court A', 'Court B']));
      });
    });

    group('updateVenue', () {
      test('updates venue fields', () async {
        await fakeFirestore.collection('venues').doc('venue123').set({
          'name': 'Original Name',
          'address': '123 Test St',
          'latitude': 37.0,
          'longitude': -122.0,
          'size': 1,
          'surface': 1,
          'environment': 1,
          'createdBy': 'user123',
          'photoCount': 1,
        });

        await service.updateVenue(
          id: 'venue123',
          data: {'name': 'Updated Name', 'photoCount': 3},
        );

        final doc =
            await fakeFirestore.collection('venues').doc('venue123').get();
        expect(doc.data()!['name'], 'Updated Name');
        expect(doc.data()!['photoCount'], 3);
      });
    });

    group('deleteVenue', () {
      test('deletes venue from Firestore', () async {
        await fakeFirestore.collection('venues').doc('venue123').set({
          'name': 'To Delete',
          'address': '123 Test St',
          'latitude': 37.0,
          'longitude': -122.0,
          'size': 1,
          'surface': 1,
          'environment': 1,
          'createdBy': 'user123',
          'photoCount': 2,
        });

        final venue = Venue(
          id: 'venue123',
          name: 'To Delete',
          address: '123 Test St',
          latitude: 37.0,
          longitude: -122.0,
          size: 1,
          surface: 1,
          environment: 1,
          createdBy: 'user123',
          photoCount: 2,
          crewMemberIds: [],
        );

        await service.deleteVenue(venue: venue);

        final doc =
            await fakeFirestore.collection('venues').doc('venue123').get();
        expect(doc.exists, false);
      });

      test('handles venue with multiple photos', () async {
        await fakeFirestore.collection('venues').doc('venue456').set({
          'name': 'Multi Photo',
          'address': '456 Test St',
          'latitude': 37.0,
          'longitude': -122.0,
          'size': 1,
          'surface': 1,
          'environment': 1,
          'createdBy': 'user123',
          'photoCount': 5,
        });

        final venue = Venue(
          id: 'venue456',
          name: 'Multi Photo',
          address: '456 Test St',
          latitude: 37.0,
          longitude: -122.0,
          size: 1,
          surface: 1,
          environment: 1,
          createdBy: 'user123',
          photoCount: 5,
          crewMemberIds: [],
        );

        // Should not throw even when files don't exist
        await service.deleteVenue(venue: venue);

        final doc =
            await fakeFirestore.collection('venues').doc('venue456').get();
        expect(doc.exists, false);
      });
    });
  });

  group('Venue model', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'id': 'venue123',
        'name': 'Test Court',
        'address': '123 Test St',
        'latitude': 37.7749,
        'longitude': -122.4194,
        'size': 2,
        'surface': 3,
        'environment': 1,
        'createdBy': 'user123',
        'photoCount': 4,
        'crewMemberIds': ['user1', 'user2'],
      };

      final venue = Venue.fromJson(json);

      expect(venue.id, 'venue123');
      expect(venue.name, 'Test Court');
      expect(venue.address, '123 Test St');
      expect(venue.latitude, 37.7749);
      expect(venue.longitude, -122.4194);
      expect(venue.size, 2);
      expect(venue.surface, 3);
      expect(venue.environment, 1);
      expect(venue.createdBy, 'user123');
      expect(venue.photoCount, 4);
      expect(venue.crewMemberIds, ['user1', 'user2']);
    });

    test('fromJson defaults photoCount to 1 when missing', () {
      final json = {
        'id': 'legacy',
        'name': 'Legacy Court',
        'address': '456 Old St',
        'latitude': 37.0,
        'longitude': -122.0,
        'size': 1,
        'surface': 1,
        'environment': 1,
        'createdBy': 'user456',
        // photoCount intentionally omitted
      };

      final venue = Venue.fromJson(json);

      expect(venue.photoCount, 1);
    });

    test('fromJson handles explicit null photoCount', () {
      final json = {
        'id': 'nullcount',
        'name': 'Null Count Court',
        'address': '789 Null St',
        'latitude': 37.0,
        'longitude': -122.0,
        'size': 1,
        'surface': 1,
        'environment': 1,
        'createdBy': 'user789',
        'photoCount': null,
      };

      final venue = Venue.fromJson(json);

      expect(venue.photoCount, 1);
    });

    test('fromJson defaults crewMemberIds to empty list when missing', () {
      final json = {
        'id': 'nocrew',
        'name': 'No Crew Court',
        'address': '123 No St',
        'latitude': 37.0,
        'longitude': -122.0,
        'size': 1,
        'surface': 1,
        'environment': 1,
        'createdBy': 'user123',
      };

      final venue = Venue.fromJson(json);

      expect(venue.crewMemberIds, isEmpty);
    });
  });
}

/// Mock FirebaseFunctions for testing
class MockFirebaseFunctions implements FirebaseFunctions {
  @override
  HttpsCallable httpsCallable(String name, {HttpsCallableOptions? options}) {
    return MockHttpsCallable();
  }

  @override
  HttpsCallable httpsCallableFromUri(Uri uri, {HttpsCallableOptions? options}) {
    return MockHttpsCallable();
  }

  @override
  HttpsCallable httpsCallableFromUrl(String url,
      {HttpsCallableOptions? options}) {
    return MockHttpsCallable();
  }

  @override
  void useFunctionsEmulator(String host, int port,
      {bool automaticHostMapping = true}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockHttpsCallable implements HttpsCallable {
  @override
  Future<HttpsCallableResult<T>> call<T>([dynamic parameters]) async {
    return MockHttpsCallableResult<T>();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockHttpsCallableResult<T> implements HttpsCallableResult<T> {
  @override
  T get data => {} as T;
}
