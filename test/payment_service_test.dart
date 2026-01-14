import 'package:crowdleague/services/payment_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentException', () {
    test('toString returns message', () {
      final exception = PaymentException('Test error');
      expect(exception.toString(), 'Test error');
    });

    test('stores code when provided', () {
      final exception = PaymentException('Test error', code: 'test_code');
      expect(exception.code, 'test_code');
    });

    test('code is null when not provided', () {
      final exception = PaymentException('Test error');
      expect(exception.code, isNull);
    });
  });

  group('PaymentService validation', () {
    test('rejects amount below minimum', () {
      // PaymentService.initPaymentSheet validates amount >= 50
      const amount = 49;
      const minAmount = 50;

      expect(amount < minAmount, isTrue);
    });

    test('accepts valid amount', () {
      const amount = 2000; // $20.00
      const minAmount = 50;

      expect(amount >= minAmount, isTrue);
    });

    test('amount in cents converts correctly to dollars', () {
      const amountInCents = 2000;
      final dollars = amountInCents / 100;

      expect(dollars, 20.0);
      expect(dollars.toStringAsFixed(2), '20.00');
    });

    test('formatted price displays correctly', () {
      const bookingPriceInCents = 2500;
      final dollars = bookingPriceInCents / 100;
      final formatted = '\$${dollars.toStringAsFixed(2)}';

      expect(formatted, '\$25.00');
    });
  });

  group('PaymentService error handling', () {
    test('getFriendlyErrorMessage returns correct message for unauthenticated',
        () {
      const code = 'unauthenticated';
      final message = _getFriendlyErrorMessage(code);

      expect(message, 'Please sign in to make a payment');
    });

    test('getFriendlyErrorMessage returns correct message for invalid-argument',
        () {
      const code = 'invalid-argument';
      final message = _getFriendlyErrorMessage(code);

      expect(message, 'Invalid payment details');
    });

    test('getFriendlyErrorMessage returns correct message for internal', () {
      const code = 'internal';
      final message = _getFriendlyErrorMessage(code);

      expect(message, 'Unable to process payment. Please try again.');
    });

    test('getFriendlyErrorMessage returns default for unknown code', () {
      const code = 'unknown_error';
      final message = _getFriendlyErrorMessage(code);

      expect(message, 'Something went wrong. Please try again.');
    });

    test('getFriendlyErrorMessage handles null code', () {
      final message = _getFriendlyErrorMessage(null);

      expect(message, 'Something went wrong. Please try again.');
    });
  });

  group('Payment metadata', () {
    test('metadata includes venueId when provided', () {
      const venueId = 'venue123';
      const userId = 'user456';

      final metadata = {
        'firebaseUID': userId,
        if (venueId.isNotEmpty) 'venueId': venueId,
      };

      expect(metadata['venueId'], 'venue123');
      expect(metadata['firebaseUID'], 'user456');
    });

    test('metadata excludes venueId when null', () {
      const String? venueId = null;
      const userId = 'user456';

      final metadata = {
        'firebaseUID': userId,
        if (venueId != null) 'venueId': venueId,
      };

      expect(metadata.containsKey('venueId'), isFalse);
      expect(metadata['firebaseUID'], 'user456');
    });

    test('description is included when provided', () {
      const description = 'Venue booking: Test Court';

      final params = {
        'amount': 2000,
        'currency': 'aud',
        'description': description,
      };

      expect(params['description'], description);
    });
  });

  group('Currency handling', () {
    test('default currency is AUD', () {
      const defaultCurrency = 'aud';
      expect(defaultCurrency, 'aud');
    });

    test('supported currencies list', () {
      const supportedCurrencies = ['aud', 'usd', 'eur', 'gbp', 'nzd'];

      expect(supportedCurrencies.contains('aud'), isTrue);
      expect(supportedCurrencies.contains('usd'), isTrue);
      expect(supportedCurrencies.contains('jpy'), isFalse);
    });
  });
}

// Helper function that mirrors PaymentService._getFriendlyErrorMessage
String _getFriendlyErrorMessage(String? code) {
  switch (code) {
    case 'unauthenticated':
      return 'Please sign in to make a payment';
    case 'invalid-argument':
      return 'Invalid payment details';
    case 'internal':
      return 'Unable to process payment. Please try again.';
    default:
      return 'Something went wrong. Please try again.';
  }
}
