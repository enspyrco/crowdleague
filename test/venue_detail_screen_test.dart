import 'package:cloud_functions/cloud_functions.dart';
import 'package:crowdleague/players/enums/pic_size.dart';
import 'package:crowdleague/venues/venues_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for VenueDetailScreen URL generation and related venue display logic.
/// Widget tests requiring full Firebase initialization are skipped due to
/// complexity of mocking UserService with CloudFunctions.
void main() {
  group('VenuesService URL generation for VenueDetailScreen', () {
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

    test('generates correct URL format for PageView display', () {
      // When displaying photos in PageView, we use medium size
      final url0 =
          service.getPhotoUrl('venue123', PicSize.medium, photoIndex: 0);
      final url1 =
          service.getPhotoUrl('venue123', PicSize.medium, photoIndex: 1);
      final url2 =
          service.getPhotoUrl('venue123', PicSize.medium, photoIndex: 2);

      expect(url0, contains('venue123_0_medium.jpg'));
      expect(url1, contains('venue123_1_medium.jpg'));
      expect(url2, contains('venue123_2_medium.jpg'));

      // All URLs should point to the venues bucket
      expect(url0, contains('crowdleague-venues'));
      expect(url1, contains('crowdleague-venues'));
      expect(url2, contains('crowdleague-venues'));
    });

    test('getAllPhotoUrls returns correct list for venue with 5 photos', () {
      final urls = service.getAllPhotoUrls('venue123', 5, PicSize.medium);

      expect(urls.length, 5);
      for (int i = 0; i < 5; i++) {
        expect(urls[i], contains('venue123_${i}_medium.jpg'));
      }
    });

    test('getAllPhotoUrls returns empty list for venue with 0 photos', () {
      final urls = service.getAllPhotoUrls('venue123', 0, PicSize.medium);
      expect(urls, isEmpty);
    });

    test('getAllPhotoUrls handles single photo', () {
      final urls = service.getAllPhotoUrls('venue123', 1, PicSize.medium);
      expect(urls.length, 1);
      expect(urls[0], contains('venue123_0_medium.jpg'));
    });

    test('different sizes generate correct suffix', () {
      final small = service.getPhotoUrl('v1', PicSize.small, photoIndex: 0);
      final medium = service.getPhotoUrl('v1', PicSize.medium, photoIndex: 0);
      final large = service.getPhotoUrl('v1', PicSize.large, photoIndex: 0);

      expect(small, contains('_small.jpg'));
      expect(medium, contains('_medium.jpg'));
      expect(large, contains('_large.jpg'));
    });

    test('retrieveVenue returns correct photoCount', () async {
      await fakeFirestore.collection('venues').doc('venue123').set({
        'name': 'Test Court',
        'address': '123 Test St',
        'latitude': 37.0,
        'longitude': -122.0,
        'size': 1,
        'surface': 1,
        'environment': 1,
        'createdBy': 'user123',
        'photoCount': 3,
      });

      final venue = await service.retrieveVenue('venue123');

      expect(venue, isNotNull);
      expect(venue!.photoCount, 3);
    });

    test('retrieveVenue defaults photoCount to 1 for legacy venues', () async {
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
        // No photoCount field - simulating a legacy venue
      });

      final venue = await service.retrieveVenue('legacy');

      expect(venue, isNotNull);
      expect(venue!.photoCount, 1);
    });

    test('deleteVenue handles venue with multiple photos', () async {
      await fakeFirestore.collection('venues').doc('venue123').set({
        'name': 'Multi Photo Court',
        'address': '789 Photo St',
        'latitude': 37.0,
        'longitude': -122.0,
        'size': 1,
        'surface': 1,
        'environment': 1,
        'createdBy': 'user123',
        'photoCount': 5,
      });

      final venue = await service.retrieveVenue('venue123');
      expect(venue, isNotNull);

      // Should not throw even when storage files don't exist
      await service.deleteVenue(venue: venue!);

      // Verify Firestore document is deleted
      final deleted = await service.retrieveVenue('venue123');
      expect(deleted, isNull);
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
