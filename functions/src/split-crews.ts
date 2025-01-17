import {FieldValue, getFirestore} from 'firebase-admin/firestore';
import {log} from 'firebase-functions/logger';
import {HttpsError, onCall} from 'firebase-functions/v2/https';

export const splitCrews = onCall(
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

      // Remove the requester's crew id any follower id
      await db.collection('profiles').doc(request.data.requesteeId)
        .set({
          crewIds: FieldValue.arrayRemove(request.data.requesterId),
          followerIds: FieldValue.arrayRemove(request.data.requesterId),
        }, {merge: true});
      log('Removed the requester\'s crew id and fcm token as followers');

      // Remove the requestee's crew id and fcm token as followers
      await db.collection('profiles').doc(request.data.requesterId)
        .set({
          crewIds: FieldValue.arrayRemove(request.data.requesteeId),
          followerIds: FieldValue.arrayRemove(request.data.requesteeId),
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
    } catch (e) {
      throw new HttpsError('aborted', `${e}.`);
    }
  });
