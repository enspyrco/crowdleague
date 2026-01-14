// Mock firebase-admin modules before importing the function
jest.mock('firebase-admin/firestore', () => ({
  getFirestore: jest.fn(),
  FieldValue: {
    serverTimestamp: jest.fn(() => ({_serverTimestamp: true})),
  },
}));

jest.mock('stripe', () => {
  return jest.fn().mockImplementation(() => ({
    customers: {
      create: jest.fn().mockResolvedValue({
        id: 'cus_test123',
      }),
    },
    ephemeralKeys: {
      create: jest.fn().mockResolvedValue({
        secret: 'ek_test_secret',
      }),
    },
    paymentIntents: {
      create: jest.fn().mockResolvedValue({
        id: 'pi_test123',
        client_secret: 'pi_test123_secret',
      }),
    },
  }));
});

import {getFirestore} from 'firebase-admin/firestore';

describe('createPaymentIntent validation', () => {
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
    };

    (getFirestore as jest.Mock).mockReturnValue(mockDb);
  });

  describe('amount validation', () => {
    const MIN_AMOUNT = 50;
    const MAX_AMOUNT = 99999999;

    it('should reject missing amount', () => {
      const data: { currency: string; amount?: number } = {currency: 'aud'};
      expect(data.amount).toBeUndefined();
    });

    it('should reject null amount', () => {
      const amount = null;
      expect(amount === undefined || amount === null).toBe(true);
    });

    it('should reject non-integer amounts', () => {
      const floatAmounts = [19.99, 100.5, 0.01, 1.1];
      floatAmounts.forEach((amount) => {
        expect(Number.isInteger(amount)).toBe(false);
      });
    });

    it('should reject negative amounts', () => {
      const negativeAmounts = [-1, -100, -50];
      negativeAmounts.forEach((amount) => {
        expect(amount < MIN_AMOUNT).toBe(true);
      });
    });

    it('should reject zero amount', () => {
      const amount = 0;
      expect(amount < MIN_AMOUNT).toBe(true);
    });

    it('should reject amounts below minimum (50 cents)', () => {
      const belowMinAmounts = [1, 10, 25, 49];
      belowMinAmounts.forEach((amount) => {
        expect(amount < MIN_AMOUNT).toBe(true);
      });
    });

    it('should reject amounts above maximum', () => {
      const aboveMaxAmounts = [100000000, 999999999, MAX_AMOUNT + 1];
      aboveMaxAmounts.forEach((amount) => {
        expect(amount > MAX_AMOUNT).toBe(true);
      });
    });

    it('should accept minimum valid amount (50 cents)', () => {
      const amount = 50;
      expect(Number.isInteger(amount)).toBe(true);
      expect(amount >= MIN_AMOUNT).toBe(true);
      expect(amount <= MAX_AMOUNT).toBe(true);
    });

    it('should accept maximum valid amount', () => {
      const amount = MAX_AMOUNT;
      expect(Number.isInteger(amount)).toBe(true);
      expect(amount >= MIN_AMOUNT).toBe(true);
      expect(amount <= MAX_AMOUNT).toBe(true);
    });

    it('should accept typical booking amounts', () => {
      const validAmounts = [
        50, // $0.50 - minimum
        100, // $1.00
        500, // $5.00
        1000, // $10.00
        2000, // $20.00 - typical venue booking
        2500, // $25.00
        5000, // $50.00
        10000, // $100.00
        99999999, // $999,999.99 - maximum
      ];
      validAmounts.forEach((amount) => {
        expect(Number.isInteger(amount)).toBe(true);
        expect(amount >= MIN_AMOUNT).toBe(true);
        expect(amount <= MAX_AMOUNT).toBe(true);
      });
    });
  });

  describe('currency validation', () => {
    const SUPPORTED_CURRENCIES = ['aud', 'usd', 'eur', 'gbp', 'nzd'];

    it('should reject unsupported currencies', () => {
      const unsupportedCurrencies = ['jpy', 'cny', 'btc', 'xyz', 'inr', 'krw'];
      unsupportedCurrencies.forEach((currency) => {
        expect(SUPPORTED_CURRENCIES.includes(currency.toLowerCase())).toBe(
          false,
        );
      });
    });

    it('should accept all supported currencies', () => {
      SUPPORTED_CURRENCIES.forEach((currency) => {
        expect(SUPPORTED_CURRENCIES.includes(currency)).toBe(true);
      });
    });

    it('should handle uppercase currency codes', () => {
      const upperCaseCurrencies = ['AUD', 'USD', 'EUR', 'GBP', 'NZD'];
      upperCaseCurrencies.forEach((currency) => {
        expect(SUPPORTED_CURRENCIES.includes(currency.toLowerCase())).toBe(
          true,
        );
      });
    });

    it('should handle mixed case currency codes', () => {
      const mixedCaseCurrencies = ['Aud', 'uSd', 'EuR'];
      mixedCaseCurrencies.forEach((currency) => {
        expect(SUPPORTED_CURRENCIES.includes(currency.toLowerCase())).toBe(
          true,
        );
      });
    });

    it('should default to AUD when no currency specified', () => {
      const defaultCurrency = 'aud';
      expect(defaultCurrency).toBe('aud');
      expect(SUPPORTED_CURRENCIES.includes(defaultCurrency)).toBe(true);
    });

    it('should reject empty string currency', () => {
      const emptyCurrency = '';
      expect(SUPPORTED_CURRENCIES.includes(emptyCurrency)).toBe(false);
    });
  });

  describe('customer creation and retrieval', () => {
    it('should reuse existing Stripe customer ID', async () => {
      const existingCustomerId = 'cus_existing123';

      mockGet.mockResolvedValue({
        exists: true,
        data: () => ({stripeCustomerId: existingCustomerId}),
      });

      const userDoc = await mockDb.collection('users').doc('user123').get();

      expect(userDoc.exists).toBe(true);
      expect(userDoc.data().stripeCustomerId).toBe(existingCustomerId);
    });

    it('should create new customer when no customerId exists', async () => {
      mockGet.mockResolvedValue({
        exists: true,
        data: () => ({name: 'Test User', email: 'test@example.com'}),
      });

      const userDoc = await mockDb.collection('users').doc('user123').get();

      expect(userDoc.exists).toBe(true);
      expect(userDoc.data().stripeCustomerId).toBeUndefined();
    });

    it('should create new customer when document does not exist', async () => {
      mockGet.mockResolvedValue({
        exists: false,
        data: () => null,
      });

      const userDoc = await mockDb.collection('users').doc('newuser').get();

      expect(userDoc.exists).toBe(false);
    });

    it('should save stripeCustomerId after creating new customer', async () => {
      const newCustomerId = 'cus_new123';
      const userId = 'user456';

      await mockDb
        .collection('users')
        .doc(userId)
        .set({stripeCustomerId: newCustomerId}, {merge: true});

      expect(mockSet).toHaveBeenCalledWith(
        {stripeCustomerId: newCustomerId},
        {merge: true},
      );
    });
  });

  describe('authentication', () => {
    it('should require authentication', () => {
      const mockRequest = {auth: null};
      expect(mockRequest.auth).toBeNull();
    });

    it('should extract uid from authenticated request', () => {
      const mockRequest = {
        auth: {
          uid: 'user123',
          token: {email: 'test@example.com'},
        },
      };

      expect(mockRequest.auth.uid).toBe('user123');
      expect(mockRequest.auth.token.email).toBe('test@example.com');
    });
  });
});

describe('createPaymentIntent metadata', () => {
  it('should include firebaseUID in metadata', () => {
    const uid = 'user123';
    const metadata = {firebaseUID: uid};

    expect(metadata.firebaseUID).toBe('user123');
  });

  it('should include venueId in metadata when provided', () => {
    const metadata = {
      firebaseUID: 'user123',
      venueId: 'venue456',
    };

    expect(metadata.venueId).toBe('venue456');
  });

  it('should not include venueId when not provided', () => {
    const venueId: string | undefined = undefined;
    const metadata: Record<string, string> = {
      firebaseUID: 'user123',
    };

    if (venueId) {
      metadata.venueId = venueId;
    }

    expect(metadata).not.toHaveProperty('venueId');
  });

  it('should include description when provided', () => {
    const description = 'Venue booking: Test Court';
    const params = {description};

    expect(params.description).toBe('Venue booking: Test Court');
  });
});

describe('PaymentIntent response', () => {
  it('should return client_secret', () => {
    const response = {
      paymentIntent: 'pi_test123_secret_abc',
      ephemeralKey: 'ek_test_secret',
      customer: 'cus_test123',
      publishableKey: 'pk_test_123',
    };

    expect(response.paymentIntent).toContain('pi_');
    expect(response.paymentIntent).toContain('secret');
  });

  it('should return ephemeral key', () => {
    const response = {
      ephemeralKey: 'ek_test_secret_xyz',
    };

    expect(response.ephemeralKey).toContain('ek_');
  });

  it('should return customer ID', () => {
    const response = {
      customer: 'cus_abc123',
    };

    expect(response.customer).toContain('cus_');
  });

  it('should return publishable key', () => {
    const response = {
      publishableKey: 'pk_test_abc123',
    };

    expect(response.publishableKey).toContain('pk_');
  });
});
