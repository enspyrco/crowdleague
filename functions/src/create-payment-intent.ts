import * as admin from "firebase-admin";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineString } from "firebase-functions/params";
import * as logger from "firebase-functions/logger";
import Stripe from "stripe";

const db = admin.firestore();

// Define environment variables - loaded from .env at runtime
const stripeSecretKey = defineString("STRIPE_SECRET_KEY");
const stripePublishableKey = defineString("STRIPE_PUBLISHABLE_KEY");

// Supported currencies
const SUPPORTED_CURRENCIES = ["aud", "usd", "eur", "gbp", "nzd"];

// Amount limits (in cents)
const MIN_AMOUNT = 50; // Stripe minimum is 50 cents
const MAX_AMOUNT = 99999999; // $999,999.99

export const createPaymentIntent = onCall(
  {
    region: "us-central1",
    cors: true,
  },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError(
        "unauthenticated",
        "The function must be called while authenticated.",
      );
    }

    const { amount, currency = "aud", venueId, description } = request.data;
    const uid = request.auth.uid;
    const email = request.auth.token.email;

    // Validate amount
    if (amount === undefined || amount === null) {
      throw new HttpsError(
        "invalid-argument",
        "The function must be called with an amount.",
      );
    }

    if (typeof amount !== "number" || !Number.isInteger(amount)) {
      throw new HttpsError(
        "invalid-argument",
        "Amount must be an integer (in cents).",
      );
    }

    if (amount < MIN_AMOUNT) {
      throw new HttpsError(
        "invalid-argument",
        `Amount must be at least ${MIN_AMOUNT} cents.`,
      );
    }

    if (amount > MAX_AMOUNT) {
      throw new HttpsError(
        "invalid-argument",
        `Amount cannot exceed ${MAX_AMOUNT} cents.`,
      );
    }

    // Validate currency
    const normalizedCurrency = currency.toLowerCase();
    if (!SUPPORTED_CURRENCIES.includes(normalizedCurrency)) {
      throw new HttpsError(
        "invalid-argument",
        `Currency must be one of: ${SUPPORTED_CURRENCIES.join(", ")}.`,
      );
    }

    // Initialize Stripe inside the function with the secret
    const stripe = new Stripe(stripeSecretKey.value(), {
      apiVersion: "2025-12-15.clover",
    });

    try {
      // 1. Get or create a Stripe Customer for this user
      let customerId: string;
      const userDocRef = db.collection("users").doc(uid);
      const userDoc = await userDocRef.get();

      // Check if user already has a stripeCustomerId
      if (userDoc.exists && userDoc.data()?.stripeCustomerId) {
        customerId = userDoc.data()?.stripeCustomerId;
      } else {
        // Create a new Customer in Stripe
        const customer = await stripe.customers.create({
          email: email,
          metadata: {
            firebaseUID: uid,
          },
        });
        customerId = customer.id;

        // Save the stripeCustomerId to Firestore
        await userDocRef.set({ stripeCustomerId: customerId }, { merge: true });
      }

      // 2. Generate an Ephemeral Key for temporary customer access
      const ephemeralKey = await stripe.ephemeralKeys.create(
        { customer: customerId },
        { apiVersion: "2025-12-15.clover" },
      );

      // 3. Create a PaymentIntent with metadata for tracking
      const paymentIntentParams: Stripe.PaymentIntentCreateParams = {
        amount: amount,
        currency: normalizedCurrency,
        customer: customerId,
        automatic_payment_methods: {
          enabled: true,
        },
        metadata: {
          firebaseUID: uid,
          ...(venueId && { venueId }),
        },
      };

      if (description) {
        paymentIntentParams.description = description;
      }

      const paymentIntent =
        await stripe.paymentIntents.create(paymentIntentParams);

      // 4. Return the necessary keys to the client
      return {
        paymentIntent: paymentIntent.client_secret,
        ephemeralKey: ephemeralKey.secret,
        customer: customerId,
        publishableKey: stripePublishableKey.value(),
      };
    } catch (error) {
      logger.error("Error creating payment intent:", error);
      throw new HttpsError("internal", "Unable to create payment intent.");
    }
  },
);
