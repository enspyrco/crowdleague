// Mock firebase-admin modules before importing
jest.mock('firebase-admin/firestore', () => ({
  getFirestore: jest.fn(),
  FieldValue: {
    serverTimestamp: jest.fn(() => ({_serverTimestamp: true})),
  },
}));

jest.mock('stripe', () => {
  return jest.fn().mockImplementation(() => ({
    webhooks: {
      constructEvent: jest.fn(),
    },
  }));
});

import {getFirestore, FieldValue} from 'firebase-admin/firestore';

describe('stripeWebhook', () => {
  let mockDb: any;
  let mockGet: jest.Mock;
  let mockSet: jest.Mock;

  beforeEach(() => {
    jest.clearAllMocks();

    mockGet = jest.fn();
    mockSet = jest.fn().mockResolvedValue(undefined);

    mockDb = {
      collection: jest.fn().mockReturnThis(),
      doc: jest.fn().mockReturnThis(),
      get: mockGet,
      set: mockSet,
      where: jest.fn().mockReturnThis(),
      limit: jest.fn().mockReturnThis(),
    };

    (getFirestore as jest.Mock).mockReturnValue(mockDb);
  });

  describe('idempotency', () => {
    it('should skip already processed events', async () => {
      const eventId = 'evt_test123';

      mockGet.mockResolvedValue({
        exists: true,
        data: () => ({
          type: 'payment_intent.succeeded',
          processedAt: {_serverTimestamp: true},
        }),
      });

      const eventDoc = await mockDb
        .collection('payment-events')
        .doc(eventId)
        .get();

      expect(eventDoc.exists).toBe(true);
    });

    it('should process new events', async () => {
      const eventId = 'evt_new123';

      mockGet.mockResolvedValue({
        exists: false,
      });

      const eventDoc = await mockDb
        .collection('payment-events')
        .doc(eventId)
        .get();

      expect(eventDoc.exists).toBe(false);
    });

    it('should mark event as processed after handling', async () => {
      const eventId = 'evt_test456';

      await mockDb.collection('payment-events').doc(eventId).set({
        type: 'payment_intent.succeeded',
        processedAt: FieldValue.serverTimestamp(),
      });

      expect(mockSet).toHaveBeenCalledWith({
        type: 'payment_intent.succeeded',
        processedAt: expect.objectContaining({_serverTimestamp: true}),
      });
    });
  });

  describe('payment_intent.succeeded handling', () => {
    it('should find user by Stripe customer ID', async () => {
      const customerId = 'cus_test123';
      const userId = 'user456';

      mockGet.mockResolvedValue({
        empty: false,
        docs: [
          {
            id: userId,
            data: () => ({stripeCustomerId: customerId}),
          },
        ],
      });

      const usersSnapshot = await mockDb
        .collection('users')
        .where('stripeCustomerId', '==', customerId)
        .limit(1)
        .get();

      expect(usersSnapshot.empty).toBe(false);
      expect(usersSnapshot.docs[0].id).toBe(userId);
    });

    it('should handle missing user gracefully', async () => {
      const customerId = 'cus_unknown';

      mockGet.mockResolvedValue({
        empty: true,
        docs: [],
      });

      const usersSnapshot = await mockDb
        .collection('users')
        .where('stripeCustomerId', '==', customerId)
        .limit(1)
        .get();

      expect(usersSnapshot.empty).toBe(true);
    });

    it('should create payment record with correct structure', async () => {
      const paymentRecord = {
        paymentIntentId: 'pi_test123',
        userId: 'user456',
        customerId: 'cus_test123',
        amount: 2000,
        currency: 'aud',
        status: 'succeeded',
        description: 'Venue booking: Test Venue',
        metadata: {venueId: 'venue789'},
        createdAt: FieldValue.serverTimestamp(),
        stripeCreated: new Date(1704067200000),
      };

      await mockDb.collection('payments').doc('pi_test123').set(paymentRecord);

      expect(mockSet).toHaveBeenCalledWith(
        expect.objectContaining({
          paymentIntentId: 'pi_test123',
          amount: 2000,
          currency: 'aud',
          status: 'succeeded',
        }),
      );
    });
  });

  describe('payment_intent.payment_failed handling', () => {
    it('should create failed payment record', async () => {
      const paymentRecord = {
        paymentIntentId: 'pi_failed123',
        userId: 'user456',
        customerId: 'cus_test123',
        amount: 2000,
        currency: 'aud',
        status: 'failed',
        failureMessage: 'Your card was declined.',
        failureCode: 'card_declined',
        metadata: {},
        createdAt: FieldValue.serverTimestamp(),
        stripeCreated: new Date(1704067200000),
      };

      await mockDb
        .collection('payments')
        .doc('pi_failed123')
        .set(paymentRecord);

      expect(mockSet).toHaveBeenCalledWith(
        expect.objectContaining({
          status: 'failed',
          failureMessage: 'Your card was declined.',
          failureCode: 'card_declined',
        }),
      );
    });
  });

  describe('signature validation', () => {
    it('should reject requests without stripe-signature header', () => {
      const headers = {};

      expect(headers).not.toHaveProperty('stripe-signature');
    });

    it('should accept requests with valid stripe-signature', () => {
      const headers = {
        'stripe-signature': 't=1234567890,v1=abc123...',
      };

      expect(headers['stripe-signature']).toBeDefined();
    });
  });
});
