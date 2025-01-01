import {FieldValue, getFirestore} from 'firebase-admin/firestore';
import {getMessaging} from 'firebase-admin/messaging';
import {HttpsError, onCall} from 'firebase-functions/v2/https';

export const followBack = onCall(
  {cors: true},
  async (request) => {
    try {
      if (!request.auth) {
        throw new HttpsError('unauthenticated', 'request.auth was undefined.');
      }

      const db = getFirestore('firestore-usa');

      await db.collection('notifications')
        .doc(`${request.data.notificationId}`).delete();

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

      // Fetch the requester's profile
      const profileDoc = await db
        .doc(`profiles/${request.data.requesteeId}`).get();
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
          title: 'Your squad is growing',
          body: `${profileDocData?.name} followed you`,
        },
        token: tokenData?.token,
      };

      await db.collection('followers').doc(request.data.requesterId)
        .set({
          tokens: FieldValue.arrayUnion(tokenData.token),
          ids: FieldValue.arrayUnion(request.data.requesteeId),
        }, {merge: true});

      // Send a message to the device
      try {
        await getMessaging().send(message);
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
