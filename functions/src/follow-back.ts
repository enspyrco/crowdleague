import {FieldValue, getFirestore} from 'firebase-admin/firestore';
import {log} from 'firebase-functions/logger';
import {HttpsError, onCall} from 'firebase-functions/v2/https';

export const followBack = onCall(
  {cors: true},
  async (request) => {
    try {
      if (!request.auth) {
        throw new HttpsError('unauthenticated', 'request.auth was undefined.');
      }

      const db = getFirestore('firestore-usa');

      // Delete the "follow back" notification
      await db.collection('notifications')
        .doc(`${request.data.notificationId}`).delete();
      log('Deleted the "follow back" notification');

      // Get the requestee's fcm token
      const tokenSnapshot = await db
        .doc(`fcmTokens/${request.data.requesteeId}`).get();
      if (!tokenSnapshot.exists) {
        throw new HttpsError('not-found', 'Token snapshot did not exist.');
      }
      const tokenData = tokenSnapshot.data();
      if (!tokenData) {
        throw new HttpsError('not-found',
          'Token snapshot.data() was undefined.');
      }
      log('Got the requestee\'s fcm token');

      // Add requestee to requester's followers
      await db.collection('followers').doc(request.data.requesterId)
        .set({
          tokens: FieldValue.arrayUnion(tokenData.token),
          ids: FieldValue.arrayUnion(request.data.requesteeId),
        }, {merge: true});
      log('Added requestee to requester\'s followers');

      return true;
    } catch (e) {
      throw new HttpsError('unknown', `${e}.`);
    }
  });
