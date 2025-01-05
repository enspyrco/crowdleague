import {onCall, HttpsError} from 'firebase-functions/v2/https';
import {FieldValue, getFirestore} from 'firebase-admin/firestore';
import {log} from 'firebase-functions/logger';

export const acceptCrewRequest = onCall(
  {cors: true},
  async (request) => {
    try {
      if (!request.auth) {
        throw new HttpsError('unauthenticated', 'request.auth was undefined.');
      }

      const db = getFirestore('firestore-usa');

      // Remove the pending member and add the crew member
      await db.collection('profiles')
        .doc(`${request.data.requesteeId}`).update({
          pendingCrewRequests:
            FieldValue.arrayRemove(request.data.requesterId),
        });
      await db.collection('profiles')
        .doc(`${request.data.requesteeId}`).update({
          crew:
            FieldValue.arrayUnion(request.data.requesterId),
        });
      await db.collection('profiles')
        .doc(`${request.data.requesterId}`).update({
          crew:
            FieldValue.arrayUnion(request.data.requesteeId),
        });
      log('Removed the pending member and added the crew members');

      // Get the requestee & requester's fcm token
      const requesterTokenSnapshot = await db.collection('fcmTokens')
        .doc(`${request.data.requesterId}`).get();
      const requesteeTokenSnapshot = await db.collection('fcmTokens')
        .doc(`${request.auth.uid}`).get();
      if (!requesterTokenSnapshot.exists || !requesteeTokenSnapshot.exists) {
        throw new HttpsError('not-found', 'Token snapshot did not exist.');
      }
      const requesterTokenData = requesterTokenSnapshot.data();
      const requesteeTokenData = requesteeTokenSnapshot.data();
      if (!requesterTokenData || !requesteeTokenData) {
        throw new HttpsError('not-found', 'Token snapshot.data() ' +
          'was undefined.');
      }
      log('Got the requester\'s and requestee\'s fcm token');

      // Store the requestee's id and fcm token in followers
      await db.collection('followers').doc(request.auth.uid)
        .set({
          tokensAndIds: FieldValue.arrayUnion(
            {token: requesterTokenData.token, uid: request.data.requesterId}
          ),
        }, {merge: true});
      log('Stored the requestee\'s id and fcm token in followers');

      // Store the requester's id and fcm token in followers
      await db.collection('followers').doc(request.data.requesterId)
        .set({
          tokensAndIds: FieldValue.arrayUnion(
            {token: requesteeTokenData.token, uid: request.auth.uid}
          ),
        }, {merge: true});
      log('Stored the requester\'s id and fcm token in followers');

      // Change the type of the notification to a CrewAcceptedNotification
      await db
        .collection('notifications').doc(request.data.notificationId)
        .update({
          type: 'crew-accepted',
          waiting: false,
        });
      log('Changed the type of the notification to a CrewAcceptedNotification');

      // Add a notification to the requestee's notifications list
      await db
        .collection('notifications').doc()
        .set({
          playerId: request.data.requesterId,
          type: 'crew-accepted',
          requesteeId: request.data.requesterId,
          requesterId: request.data.requesteeId,
          timestamp: FieldValue.serverTimestamp(),
          opened: false,
          viewed: false,
          waiting: false,
        });
      log('CrewAcceptedNotification added to notifications/' +
      `${request.data.requesterId}`);
    } catch (e) {
      throw new HttpsError('unknown', `${e}`);
    }

    return true;
  });
