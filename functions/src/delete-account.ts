import {onCall, HttpsError} from 'firebase-functions/v2/https';
import {FieldValue, getFirestore} from 'firebase-admin/firestore';
import {getAuth} from 'firebase-admin/auth';
import {Storage} from '@google-cloud/storage';
import {log, error as logError} from 'firebase-functions/logger';

const BUCKET_NAME = 'crowdleague-project.firebasestorage.app';

export const deleteAccount = onCall(
  {
    cors: true,
    region: 'us-central1',
  },
  async (request) => {
    // Verify authentication
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'request.auth was undefined.');
    }

    const userId = request.auth.uid;
    const db = getFirestore(request.data.dbName);
    const storage = new Storage();
    const bucket = storage.bucket(BUCKET_NAME);

    log(`Starting account deletion for user: ${userId}`);

    try {
      // 1. Delete user's notifications
      log('Deleting notifications...');
      const notificationsQuery = await db.collection('notifications')
        .where('playerId', '==', userId)
        .get();

      const notificationDeletes = notificationsQuery.docs.map((doc) =>
        doc.ref.delete()
      );
      await Promise.all(notificationDeletes);
      log(`Deleted ${notificationsQuery.size} notifications`);

      // 2. Clean up crew relationships - remove user from other users' profiles
      log('Cleaning up crew relationships...');

      // Find profiles where user is in crewIds
      const crewQuery = await db.collection('profiles')
        .where('crewIds', 'array-contains', userId)
        .get();

      const crewUpdates = crewQuery.docs.map((doc) =>
        doc.ref.update({
          crewIds: FieldValue.arrayRemove(userId),
          followerIds: FieldValue.arrayRemove(userId),
        })
      );
      await Promise.all(crewUpdates);
      log(`Removed user from ${crewQuery.size} crew lists`);

      // Find profiles where user has pending crew requests
      const pendingQuery = await db.collection('profiles')
        .where('pendingCrewRequests', 'array-contains', userId)
        .get();

      const pendingUpdates = pendingQuery.docs.map((doc) =>
        doc.ref.update({
          pendingCrewRequests: FieldValue.arrayRemove(userId),
        })
      );
      await Promise.all(pendingUpdates);
      log(`Removed user from ${pendingQuery.size} pending requests`);

      // 3. Anonymize messages where user is sender
      log('Anonymizing messages...');
      const conversationsSnapshot = await db.collection('conversations').get();
      let messageCount = 0;

      for (const convDoc of conversationsSnapshot.docs) {
        const messagesQuery = await convDoc.ref.collection('messages')
          .where('senderId', '==', userId)
          .get();

        const messageUpdates = messagesQuery.docs.map((msgDoc) =>
          msgDoc.ref.update({
            senderId: 'deleted-user',
          })
        );
        await Promise.all(messageUpdates);
        messageCount += messagesQuery.size;
      }
      log(`Anonymized ${messageCount} messages`);

      // 4. Delete profile photos from Storage
      log('Deleting profile photos...');
      try {
        const [files] = await bucket.getFiles({prefix: `profiles/${userId}/`});
        const deletePromises = files.map((file) => file.delete());
        await Promise.all(deletePromises);
        log(`Deleted ${files.length} profile photos`);
      } catch (storageError) {
        // Storage files may not exist, log but continue
        logError('Storage deletion error (may be empty):', storageError);
      }

      // 5. Delete FCM token document
      log('Deleting FCM token...');
      try {
        await db.collection('fcmTokens').doc(userId).delete();
        log('Deleted FCM token');
      } catch (fcmError) {
        logError('FCM token deletion error:', fcmError);
      }

      // 6. Delete user profile document
      log('Deleting user profile...');
      await db.collection('profiles').doc(userId).delete();
      log('Deleted user profile');

      // 7. Delete Firebase Auth account (MUST BE LAST)
      log('Deleting Firebase Auth account...');
      await getAuth().deleteUser(userId);
      log('Deleted Firebase Auth account');

      log(`Account deletion completed for user: ${userId}`);
      return {success: true};
    } catch (e) {
      logError('Account deletion failed:', e);
      throw new HttpsError('aborted', `Account deletion failed: ${e}`);
    }
  });
