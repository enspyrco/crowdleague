import {FieldValue, getFirestore} from 'firebase-admin/firestore';
import {log} from 'firebase-functions/logger';
import {HttpsError, onCall} from 'firebase-functions/v2/https';

export const joinVenueCrew = onCall(
  {
    cors: true,
    region: 'us-central1',
  },
  async (request) => {
    try {
      if (!request.auth) {
        throw new HttpsError('unauthenticated', 'User must be authenticated.');
      }

      const userId = request.auth.uid;
      const venueId = request.data.venueId;
      const dbName = request.data.dbName;

      if (!venueId) {
        throw new HttpsError('invalid-argument', 'venueId is required.');
      }

      const db = getFirestore(dbName);

      log(`User ${userId} joining venue crew ${venueId}`);

      // Use a batch to atomically update both documents
      const batch = db.batch();

      // Add user to venue's crewMemberIds
      const venueRef = db.collection('venues').doc(venueId);
      batch.update(venueRef, {
        crewMemberIds: FieldValue.arrayUnion(userId),
      });

      // Add venue to user's venueCrewIds
      const profileRef = db.collection('profiles').doc(userId);
      batch.update(profileRef, {
        venueCrewIds: FieldValue.arrayUnion(venueId),
      });

      await batch.commit();

      log(`User ${userId} successfully joined venue crew ${venueId}`);

      return {success: true};
    } catch (e) {
      log(`Error in joinVenueCrew: ${e}`);
      throw new HttpsError('aborted', `${e}`);
    }
  });
