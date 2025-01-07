import {FieldValue, getFirestore} from 'firebase-admin/firestore';
import {log} from 'firebase-functions/logger';
import {HttpsError, onCall} from 'firebase-functions/v2/https';

export const splitCrews = onCall(
  {cors: true},
  async (request) => {
    try {
      if (!request.auth) {
        throw new HttpsError('unauthenticated', 'request.auth was undefined.');
      }

      const db = getFirestore('firestore-usa');

      log(`requesteeId = ${request.data.requesteeId}, ` +
        `requesterId = ${request.data.requesterId}`);

      // Get the requestee & requester's fcm token
      const requesterTokenSnapshot = await db.collection('fcmTokens')
        .doc(`${request.data.requesterId}`).get();
      const requesteeTokenSnapshot = await db.collection('fcmTokens')
        .doc(`${request.data.requesteeId}`).get();
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

      // Remove the requester's crew id and fcm token as followers
      await db.collection('profiles').doc(request.data.requesteeId)
        .set({
          crewIds: FieldValue.arrayRemove(request.data.requesterId),
          followerTokens: FieldValue.arrayRemove(requesterTokenData.token),
        }, {merge: true});
      log('Removed the requester\'s crew id and fcm token as followers');

      // Remove the requestee's crew id and fcm token as followers
      await db.collection('profiles').doc(request.data.requesterId)
        .set({
          crewIds: FieldValue.arrayRemove(request.data.requesteeId),
          followerTokens: FieldValue.arrayRemove(requesteeTokenData.token),
        }, {merge: true});
      log('Removed the requestee\'s crew id and fcm token as followers');

      // Add a Notification to requester's Notifications list
      await db
        .collection('notifications').doc()
        .set({
          playerId: request.data.requesterId,
          type: 'split-crew',
          requesteeId: request.data.requesteeId,
          requesterId: request.data.requesterId,
          timestamp: FieldValue.serverTimestamp(),
          opened: false,
          viewed: false,
          waiting: false,
        });
      log(`CrewSplitNotification added for ${request.data.requesterId}`);

      return true;
    } catch (e) {
      throw new HttpsError('unknown', `${e}.`);
    }
  });
