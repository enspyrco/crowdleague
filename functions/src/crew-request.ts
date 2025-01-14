import {FieldValue, getFirestore} from 'firebase-admin/firestore';
import {getMessaging} from 'firebase-admin/messaging';
import {log} from 'firebase-functions/logger';
import {HttpsError, onCall} from 'firebase-functions/v2/https';

export const crewRequest = onCall(
  {
    cors: true,
    region: ['australia-southeast2', 'us-central1'],
  },
  async (request) => {
    try {
      if (!request.auth) {
        throw new HttpsError('unauthenticated', 'request.auth was undefined.');
      }

      const db = getFirestore(request.data.dbName);

      log(`requesteeId = ${request.data.requesteeId}, ` +
        `requesterId = ${request.data.requesterId}`);

      // Add 'pending' entry for requester to requestee's profile
      await db.collection('profiles')
        .doc(`${request.data.requesteeId}`).update({
          pendingCrewRequests:
            FieldValue.arrayUnion(request.data.requesterId),
        });

      // Add a notification to the requestee's notifications list
      await db
        .collection('notifications').doc()
        .set({
          playerId: request.data.requesteeId,
          type: 'crew-request',
          requesteeId: request.data.requesteeId,
          requesterId: request.data.requesterId,
          timestamp: FieldValue.serverTimestamp(),
          opened: false,
          viewed: false,
          waiting: false,
        });
      log('CrewRequestNotification added to notifications/' +
        `${request.data.requesterId}`);

      // Fetch requestee token
      const tokenDoc = await db
        .doc(`fcmTokens/${request.data.requesteeId}`).get();
      if (!tokenDoc.exists) {
        throw new HttpsError('not-found', 'Token snapshot did not exist.');
      }
      const tokenData = tokenDoc.data();
      if (!tokenData) {
        throw new HttpsError('not-found',
          'Token snapshot.data() was undefined.');
      }
      log(`Fetched requestee token: ${tokenData?.token}`);

      // Fetch the requester's profile
      const profileDoc = await db
        .doc(`profiles/${request.data.requesterId}`).get();
      if (!profileDoc.exists) {
        throw new HttpsError('not-found', 'Token snapshot did not exist.');
      }
      const profileData = profileDoc.data();
      if (!profileData) {
        throw new HttpsError('not-found',
          'Token snapshot.data() was undefined.');
      }
      log('Fetched the requester\'s profile');

      // Send an FCM message to the requestee with requester's name
      const message = {
        notification: {
          title: 'Expand your crew?',
          body: `${profileData?.name} wants to join crews`,
        },
        token: tokenData?.token,
      };
      try {
        // Don't remove old tokens as we rely on them to find profiles that need
        // updating when a token refresh occurs on the client and we update the
        // fcmTokens/{playerId} doc
        await getMessaging().send(message);
        log(`Successfully sent message to: ${request.data.requesterId}`);
      } catch (error) {
        console.log(error);
      }
    } catch (e) {
      throw new HttpsError('aborted', `${e}.`);
    }
  });
