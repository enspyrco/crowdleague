import {onCall, HttpsError} from 'firebase-functions/v2/https';
import {FieldValue, getFirestore} from 'firebase-admin/firestore';

export const acceptFollowRequest = onCall(
  {cors: true},
  async (request) => {
    try {
      if (!request.auth) {
        throw new HttpsError('unauthenticated', 'request.auth was undefined.');
      }

      const db = getFirestore('firestore-usa');

      // Remove the pending member
      await db.collection('profiles')
        .doc(`${request.data.requesteeId}`).update({
          pendingFollowRequests:
            FieldValue.arrayRemove(request.data.requesterId),
        });

      // Get the requester's fcm token
      const tokenSnapshot = await db.collection('fcmTokens')
        .doc(`${request.data.requesterId}`).get();
      if (!tokenSnapshot.exists) {
        throw new HttpsError('not-found', 'Token snapshot did not exist.');
      }
      const tokenData = tokenSnapshot.data();
      if (!tokenData) {
        throw new HttpsError('not-found', 'Token snapshot.data() ' +
          'was undefined.');
      }

      // Store the requester's id and fcm token
      await db.collection('followers').doc(request.auth.uid)
        .set({
          tokens: FieldValue.arrayUnion(tokenData.token),
          ids: FieldValue.arrayUnion(request.data.requesterId),
        }, {merge: true});

      // Change the type of the notification to a FollowBackNotification
      // so the user now sees the option to "follow back"
      await db
        .collection('notifications').doc(request.data.notificationId)
        .update({
          type: 'follow-back',
          waiting: false,
        });
    } catch (e) {
      throw new HttpsError('unknown', `${e}`);
    }

    return true;
  });
