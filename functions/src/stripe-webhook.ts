import * as admin from "firebase-admin";
import { onRequest } from "firebase-functions/v2/https";
import { defineString } from "firebase-functions/params";
import * as logger from "firebase-functions/logger";
import Stripe from "stripe";

const db = admin.firestore();

// Define environment variables - loaded from .env at runtime
const stripeSecretKey = defineString("STRIPE_SECRET_KEY");
const stripeWebhookSecret = defineString("STRIPE_WEBHOOK_SECRET");

export const stripeWebhook = onRequest(
  {
    region: "us-central1",
    cors: false,
  },
  async (request, response) => {
    const sig = request.headers["stripe-signature"];

    if (!sig) {
      logger.error("Missing stripe-signature header");
      response.status(400).send("Missing stripe-signature header");
      return;
    }

    // Initialize Stripe inside the function with the secret
    const stripe = new Stripe(stripeSecretKey.value(), {
      apiVersion: "2025-12-15.clover",
    });

    let event: Stripe.Event;

    try {
      event = stripe.webhooks.constructEvent(
        request.rawBody,
        sig,
        stripeWebhookSecret.value(),
      );
    } catch (err) {
      logger.error("Webhook signature verification failed:", err);
      response.status(400).send(`Webhook Error: ${err}`);
      return;
    }

    // Idempotency check - prevent duplicate processing
    const eventRef = db.collection("payment-events").doc(event.id);
    const eventDoc = await eventRef.get();

    if (eventDoc.exists) {
      logger.info(`Event ${event.id} already processed, skipping`);
      response.status(200).send("Event already processed");
      return;
    }

    try {
      switch (event.type) {
        case "payment_intent.succeeded": {
          const paymentIntent = event.data.object as Stripe.PaymentIntent;
          await handlePaymentIntentSucceeded(paymentIntent);
          break;
        }
        case "payment_intent.payment_failed": {
          const paymentIntent = event.data.object as Stripe.PaymentIntent;
          await handlePaymentIntentFailed(paymentIntent);
          break;
        }
        default:
          logger.info(`Unhandled event type: ${event.type}`);
      }

      // Mark event as processed
      await eventRef.set({
        type: event.type,
        processedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      response.status(200).send("Webhook processed successfully");
    } catch (err) {
      logger.error("Error processing webhook:", err);
      response.status(500).send(`Error processing webhook: ${err}`);
    }
  },
);

/**
 * Handles successful payment intents by recording them in Firestore.
 * @param {Stripe.PaymentIntent} paymentIntent - The successful payment intent
 */
async function handlePaymentIntentSucceeded(
  paymentIntent: Stripe.PaymentIntent,
): Promise<void> {
  logger.info("Processing successful payment:", paymentIntent.id);

  const customerId = paymentIntent.customer as string;

  // Find the user by their Stripe customer ID
  const usersSnapshot = await db
    .collection("users")
    .where("stripeCustomerId", "==", customerId)
    .limit(1)
    .get();

  if (usersSnapshot.empty) {
    logger.error(`No user found for Stripe customer: ${customerId}`);
    return;
  }

  const userDoc = usersSnapshot.docs[0];
  const userId = userDoc.id;

  // Store payment record
  const paymentRecord = {
    paymentIntentId: paymentIntent.id,
    userId: userId,
    customerId: customerId,
    amount: paymentIntent.amount,
    currency: paymentIntent.currency,
    status: "succeeded",
    description: paymentIntent.description || null,
    metadata: paymentIntent.metadata || {},
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    stripeCreated: new Date(paymentIntent.created * 1000),
  };

  await db.collection("payments").doc(paymentIntent.id).set(paymentRecord);

  logger.info(`Payment ${paymentIntent.id} recorded for user ${userId}`);
}

/**
 * Handles failed payment intents by recording them in Firestore.
 * @param {Stripe.PaymentIntent} paymentIntent - The failed payment intent
 */
async function handlePaymentIntentFailed(
  paymentIntent: Stripe.PaymentIntent,
): Promise<void> {
  logger.info("Processing failed payment:", paymentIntent.id);

  const customerId = paymentIntent.customer as string;

  // Find the user by their Stripe customer ID
  const usersSnapshot = await db
    .collection("users")
    .where("stripeCustomerId", "==", customerId)
    .limit(1)
    .get();

  if (usersSnapshot.empty) {
    logger.error(`No user found for Stripe customer: ${customerId}`);
    return;
  }

  const userDoc = usersSnapshot.docs[0];
  const userId = userDoc.id;

  // Store failed payment record
  const paymentRecord = {
    paymentIntentId: paymentIntent.id,
    userId: userId,
    customerId: customerId,
    amount: paymentIntent.amount,
    currency: paymentIntent.currency,
    status: "failed",
    failureMessage:
      paymentIntent.last_payment_error?.message || "Unknown error",
    failureCode: paymentIntent.last_payment_error?.code || null,
    metadata: paymentIntent.metadata || {},
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    stripeCreated: new Date(paymentIntent.created * 1000),
  };

  await db.collection("payments").doc(paymentIntent.id).set(paymentRecord);

  logger.info(`Failed payment ${paymentIntent.id} recorded for user ${userId}`);
}
