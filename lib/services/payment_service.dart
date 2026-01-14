import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentException implements Exception {
  final String message;
  final String? code;

  PaymentException(this.message, {this.code});

  @override
  String toString() => message;
}

class PaymentService {
  final FirebaseFunctions _functions;
  PaymentService(this._functions);

  /// Initializes the payment sheet for a one-time payment.
  ///
  /// [amount] - Amount in cents (e.g., 2000 for $20.00)
  /// [currency] - Currency code (default: 'aud')
  /// [venueId] - Optional venue ID for booking context
  /// [description] - Optional description for the payment
  Future<void> initPaymentSheet({
    required int amount,
    String currency = 'aud',
    String? venueId,
    String? description,
  }) async {
    if (amount < 50) {
      throw PaymentException('Amount must be at least 50 cents');
    }

    try {
      // 1. Create payment intent on the backend
      final HttpsCallable callable =
          _functions.httpsCallable('createPaymentIntent');
      final result = await callable.call<Map<String, dynamic>>({
        'amount': amount,
        'currency': currency,
        if (venueId != null) 'venueId': venueId,
        if (description != null) 'description': description,
      });

      final data = result.data;
      final paymentIntentClientSecret = data['paymentIntent'];
      final ephemeralKey = data['ephemeralKey'];
      final customerId = data['customer'];
      final publishableKey = data['publishableKey'];

      // 2. Initialize the Stripe SDK with the publishable key
      Stripe.publishableKey = publishableKey;

      // 3. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'CrowdLeague',
          customerId: customerId,
          customerEphemeralKeySecret: ephemeralKey,
          paymentIntentClientSecret: paymentIntentClientSecret,
          style: ThemeMode.system,
        ),
      );
    } on FirebaseFunctionsException catch (e) {
      debugPrint('Firebase Functions error: ${e.code} - ${e.message}');
      throw PaymentException(
        _getFriendlyErrorMessage(e.code),
        code: e.code,
      );
    } catch (e) {
      debugPrint('Error initializing payment sheet: $e');
      rethrow;
    }
  }

  /// Presents the payment sheet to the user.
  ///
  /// Returns true if payment was successful.
  /// Throws [PaymentException] if payment fails or is cancelled.
  Future<bool> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      debugPrint('Payment successful');
      return true;
    } on StripeException catch (e) {
      debugPrint('Stripe error: ${e.error.code} - ${e.error.message}');

      // User cancelled - not an error
      if (e.error.code == FailureCode.Canceled) {
        throw PaymentException('Payment cancelled', code: 'cancelled');
      }

      throw PaymentException(
        e.error.localizedMessage ?? 'Payment failed',
        code: e.error.code.toString(),
      );
    } catch (e) {
      debugPrint('Unforeseen error: $e');
      rethrow;
    }
  }

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
}
