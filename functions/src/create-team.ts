import {FieldValue, getFirestore} from 'firebase-admin/firestore';
import {log} from 'firebase-functions/logger';
import {HttpsError, onCall} from 'firebase-functions/v2/https';

export const createTeam = onCall(
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
      const teamName = request.data.teamName;
      const dbName = request.data.dbName;

      if (!teamName || teamName.trim().length === 0) {
        throw new HttpsError('invalid-argument', 'Team name is required.');
      }

      const db = getFirestore(dbName);

      log(`User ${userId} creating team: ${teamName}`);

      const batch = db.batch();

      // Create team document with creator as captain and first member
      const teamRef = db.collection('teams').doc();
      batch.set(teamRef, {
        name: teamName.trim(),
        captainId: userId,
        memberIds: [userId],
        createdAt: FieldValue.serverTimestamp(),
      });

      // Add team to user's teamIds
      const profileRef = db.collection('profiles').doc(userId);
      batch.update(profileRef, {
        teamIds: FieldValue.arrayUnion(teamRef.id),
      });

      await batch.commit();

      log(`Team ${teamRef.id} created successfully`);

      return {success: true, teamId: teamRef.id};
    } catch (e) {
      log(`Error in createTeam: ${e}`);
      throw new HttpsError('aborted', `${e}`);
    }
  });
