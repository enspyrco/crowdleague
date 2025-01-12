import {onCall, HttpsError, CallableRequest} from 'firebase-functions/v2/https';
import {FieldValue, getFirestore} from 'firebase-admin/firestore';
import {log} from 'firebase-functions/logger';
import {getMessaging} from 'firebase-admin/messaging';
import {getDocumentSnapshot} from './utils';

export const acceptCrewRequestRel = onCall(
  {
    cors: true,
    region: 'australia-southeast1',
  },
  async (request) => {
    await acceptCrewRequest('(default)', request);
  });

export const acceptCrewRequestDev = onCall(
  {
    cors: true,
    region: 'us-central1',
  },
  async (request) => {
    await acceptCrewRequest('firestore-usa', request);
  });

/**
 * Accept a crew request.
 * @param {string} dbName The name of the firestore database to use.
 * @param {CallableRequest} request The original request.
 */
async function acceptCrewRequest(
  dbName: string,
  request: CallableRequest) : Promise<void> {
  try {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'request.auth was undefined.');
    }

    const db = getFirestore(dbName);

    log(`requester: ${request.data.requesterId},` +
      `requestee: ${request.data.requesteeId}`);

    // Retrieve FCM tokens
    const requesterTokenRef = db.collection('fcmTokens')
      .doc(request.data.requesterId);
    const requesterSnapshot = await getDocumentSnapshot(requesterTokenRef);
    if (!requesterSnapshot) {
      throw new HttpsError('not-found', `fcmToken/${requesterTokenRef.id}` +
        'data() was undefined.');
    }
    const requesteeTokenRef = db.collection('fcmTokens')
      .doc(request.data.requesteeId);
    const requesteeSnapshot = await getDocumentSnapshot(requesteeTokenRef);
    if (!requesteeSnapshot) {
      throw new HttpsError('not-found', `fcmToken/${requesteeTokenRef.id}` +
        'data() was undefined.');
    }
    const requesterToken = requesterSnapshot.token;
    const requesteeToken = requesteeSnapshot.token;
    log(`Retrieved FCM tokens - requester: ${requesterToken},` +
      `requestee: ${requesteeToken}`);

    // Setup variables for database references
    const requesteeProfilesRef = db.collection('profiles')
      .doc(`${request.data.requesteeId}`);
    const requesterProfilesRef = db.collection('profiles')
      .doc(`${request.data.requesterId}`);

    // Remove the pending member and add the crew members
    await requesteeProfilesRef.update({pendingCrewRequests:
      FieldValue.arrayRemove(request.data.requesterId),
    });
    await requesteeProfilesRef.update({
      crewIds: FieldValue.arrayUnion(request.data.requesterId),
    });
    await requesterProfilesRef.update({
      crewIds: FieldValue.arrayUnion(request.data.requesteeId),
    });
    log('Removed the pending member and added the crew members');

    // Store the requester & requestee's fcm token under followers
    await requesteeProfilesRef.set({
      followerTokens: FieldValue.arrayUnion(requesterToken),
    }, {merge: true});
    await requesterProfilesRef.set({
      followerTokens: FieldValue.arrayUnion(requesteeToken),
    }, {merge: true});
    log('Stored the requester\'s fcm token under followers');

    // Change the type of the notification to a CrewAcceptedNotification
    await db
      .collection('notifications').doc(request.data.notificationId)
      .update({
        type: 'crew-accepted',
        waiting: false,
        viewed: false,
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

    // Fetch the requester's & requestee's profile
    const requesterProfileSnapshot =
      await getDocumentSnapshot(requesterProfilesRef);
    const requesteeProfileSnapshot =
      await getDocumentSnapshot(requesteeProfilesRef);
    log('Retrieved the requester\'s & requestee\'s profile snapshots');

    // Send an FCM message to the requestee with requester's name
    const requesterMessage = {
      notification: {
        title: 'Your crew is growing',
        body: `${requesterProfileSnapshot?.name} is now part of your crew.`,
      },
      token: requesteeToken,
    };
    const requesteresponse = await getMessaging().send(requesterMessage);
    log(`Successfully sent message to ${request.data.requesterId} :`,
      requesteresponse);

    // Send an FCM message to the requester with requestee's name
    const requesteeMessage = {
      notification: {
        title: 'Your crew is growing',
        body: `${requesteeProfileSnapshot?.name} is now part of your crew.`,
      },
      token: requesterToken,
    };
    const requesteeResponse = await getMessaging().send(requesteeMessage);
    log(`Successfully sent message to ${request.data.requesteeId} :`,
      requesteeResponse);
  } catch (e) {
    throw new HttpsError('aborted', `${e}`);
  }
}
