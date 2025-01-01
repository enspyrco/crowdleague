// import {log} from 'firebase-functions/logger';
import {FieldValue, getFirestore} from 'firebase-admin/firestore';
import {getMessaging} from 'firebase-admin/messaging';
import {HttpsError, onCall} from 'firebase-functions/v2/https';

export const followRequest = onCall(
  {cors: true},
  async (request) => {
    try {
      if (!request.auth) {
        throw new HttpsError('unauthenticated', 'request.auth was undefined.');
      }

      console.log(`requesteeId = ${request.data.requesteeId}, ` +
        `requesterId = ${request.data.requesterId}`);

      const db = getFirestore('firestore-usa');

      // Add the requester id to the requestee's profile
      // so profile shows 'pending'
      await db.collection('profiles')
        .doc(`${request.data.requesteeId}`).update({
          pendingFollowRequests:
            FieldValue.arrayUnion(request.data.requesterId),
        });

      // Add a notification to the requestee's notifications list
      await db
        .collection('notifications').doc()
        .set({
          type: 'follow-request',
          requesteeId: request.data.requesteeId,
          requesterId: request.data.requesterId,
          timestamp: FieldValue.serverTimestamp(),
          opened: false,
          viewed: false,
        });
      console.log('Notification added to notifications/' +
        `${request.data.requesterId}`);

      const tokenDoc = await db
        .doc(`fcmTokens/${request.data.requesteeId}`).get();
      const tokenDocData = tokenDoc.data();

      if (!tokenDoc.exists) {
        throw new HttpsError('not-found', 'Token snapshot did not exist.');
      }

      const docData = tokenDoc.data();
      if (!docData) {
        throw new HttpsError('not-found',
          'Token snapshot.data() was undefined.');
      }

      // Fetch the requester's profile
      const profileDoc = await db
        .doc(`profiles/${request.data.requesterId}`).get();
      const profileDocData = profileDoc.data();

      if (!profileDoc.exists) {
        throw new HttpsError('not-found', 'Token snapshot did not exist.');
      }

      const profileData = profileDoc.data();
      if (!profileData) {
        throw new HttpsError('not-found',
          'Token snapshot.data() was undefined.');
      }

      const message = {
        notification: {
          title: 'Expand your squad?',
          body: `${profileDocData?.name} wants to follow you`,
        },
        token: tokenDocData?.token,
      };

      // Send a message to the device
      try {
        const response = await getMessaging().send(message);
        console.log('Successfully sent message:', response);
      } catch (e) {
        if (e instanceof HttpsError) {
          throw new HttpsError('unknown', `${e.toJSON()}`);
        }
      }

      return true;
    } catch (e) {
      throw new HttpsError('unknown', `${e}.`);
    }
  });
