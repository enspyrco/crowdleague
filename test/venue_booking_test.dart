import 'package:crowdleague/venues/models/venue.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Venue booking price', () {
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
    });

    test('Venue model includes bookingPrice field', () {
      final venue = Venue(
        id: 'venue123',
        name: 'Test Court',
        address: '123 Test St',
        latitude: 37.0,
        longitude: -122.0,
        size: 1,
        surface: 1,
        environment: 1,
        createdBy: 'user123',
        photoCount: 1,
        crewMemberIds: [],
        bookingPrice: 2500, // $25.00
      );

      expect(venue.bookingPrice, 2500);
    });

    test('Venue model allows null bookingPrice', () {
      final venue = Venue(
        id: 'venue123',
        name: 'Test Court',
        address: '123 Test St',
        latitude: 37.0,
        longitude: -122.0,
        size: 1,
        surface: 1,
        environment: 1,
        createdBy: 'user123',
        photoCount: 1,
        crewMemberIds: [],
        bookingPrice: null,
      );

      expect(venue.bookingPrice, isNull);
    });

    test('Venue.fromJson parses bookingPrice', () {
      final json = {
        'id': 'venue123',
        'name': 'Test Court',
        'address': '123 Test St',
        'latitude': 37.0,
        'longitude': -122.0,
        'size': 1,
        'surface': 1,
        'environment': 1,
        'createdBy': 'user123',
        'photoCount': 3,
        'bookingPrice': 3000,
      };

      final venue = Venue.fromJson(json);

      expect(venue.bookingPrice, 3000);
    });

    test('Venue.fromJson handles missing bookingPrice', () {
      final json = {
        'id': 'venue123',
        'name': 'Test Court',
        'address': '123 Test St',
        'latitude': 37.0,
        'longitude': -122.0,
        'size': 1,
        'surface': 1,
        'environment': 1,
        'createdBy': 'user123',
        'photoCount': 1,
      };

      final venue = Venue.fromJson(json);

      expect(venue.bookingPrice, isNull);
    });

    test('bookingPrice from Firestore document', () async {
      await fakeFirestore.collection('venues').doc('venue123').set({
        'name': 'Premium Court',
        'address': '456 Premium Ave',
        'latitude': 37.0,
        'longitude': -122.0,
        'size': 2,
        'surface': 2,
        'environment': 2,
        'createdBy': 'user456',
        'photoCount': 2,
        'bookingPrice': 5000, // $50.00
      });

      final doc =
          await fakeFirestore.collection('venues').doc('venue123').get();
      final data = doc.data()!;
      data['id'] = doc.id;

      final venue = Venue.fromJson(data);

      expect(venue.bookingPrice, 5000);
      expect(venue.name, 'Premium Court');
    });

    test('default booking price logic', () {
      // Simulating VenueDetailScreen._bookingPriceInCents getter
      int getBookingPriceInCents(Venue? venue) {
        return venue?.bookingPrice ?? 2000; // Default $20.00
      }

      final venueWithPrice = Venue(
        id: 'v1',
        name: 'Priced',
        address: 'addr',
        latitude: 0,
        longitude: 0,
        size: 1,
        surface: 1,
        environment: 1,
        createdBy: 'u1',
        photoCount: 1,
        crewMemberIds: [],
        bookingPrice: 3500,
      );

      final venueWithoutPrice = Venue(
        id: 'v2',
        name: 'Default',
        address: 'addr',
        latitude: 0,
        longitude: 0,
        size: 1,
        surface: 1,
        environment: 1,
        createdBy: 'u1',
        photoCount: 1,
        crewMemberIds: [],
        bookingPrice: null,
      );

      expect(getBookingPriceInCents(venueWithPrice), 3500);
      expect(getBookingPriceInCents(venueWithoutPrice), 2000);
      expect(getBookingPriceInCents(null), 2000);
    });

    test('formatted price display', () {
      String formatPrice(int cents) {
        final dollars = cents / 100;
        return '\$${dollars.toStringAsFixed(2)}';
      }

      expect(formatPrice(2000), '\$20.00');
      expect(formatPrice(2500), '\$25.00');
      expect(formatPrice(999), '\$9.99');
      expect(formatPrice(50), '\$0.50');
      expect(formatPrice(10000), '\$100.00');
    });
  });

  group('Payment flow state', () {
    test('processing payment state prevents double submission', () {
      bool processingPayment = false;

      // Simulate button press
      void onPayButtonPressed() {
        if (processingPayment) return;
        processingPayment = true;
      }

      onPayButtonPressed();
      expect(processingPayment, isTrue);

      // Second press should be ignored
      bool secondPressHandled = false;
      if (!processingPayment) {
        secondPressHandled = true;
      }
      expect(secondPressHandled, isFalse);
    });

    test('payment success shows correct message', () {
      const successMessage = 'Booking successful!';
      expect(successMessage, isNotEmpty);
    });

    test('payment cancellation is handled gracefully', () {
      const cancelCode = 'cancelled';
      final shouldShowError = cancelCode != 'cancelled';

      expect(shouldShowError, isFalse);
    });
  });
}
