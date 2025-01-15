import {Change, FirestoreEvent, onDocumentUpdated, QueryDocumentSnapshot}
  from 'firebase-functions/v2/firestore';
import {FieldValue, getFirestore} from 'firebase-admin/firestore';

interface TokenDocument {
  token: string;
}

export const updateTokensEverywhereAus = onDocumentUpdated({
  document: 'fcmTokens/{playerId}',
  database: '(default)',
  region: 'australia-southeast2',
},
async (event) => {
  return updateTokensEverywhere(event, 'australia-southeast2');
});

export const updateTokensEverywhereUsa = onDocumentUpdated({
  document: 'fcmTokens/{playerId}',
  database: 'firestore-usa',
  region: 'us-central1',
},
async (event) => {
  return updateTokensEverywhere(event, '(default)');
});

/**
 * Triggers on fcmToken document update
 * @param {FirestoreEvent<Change<QueryDocumentSnapshot> |
 *    undefined, {playerId: string}>} event
 * @param {string} dbName,
 * @return {Promise<null>}
 */
async function updateTokensEverywhere(
  event : FirestoreEvent<Change<QueryDocumentSnapshot> | undefined,
    {playerId: string}>,
  dbName : string,
): Promise<null> {
  if (!event.data) {
    throw new Error('event.data was undefined.');
  }

  const beforeData = event.data.before.data() as TokenDocument;
  const afterData = event.data.after.data() as TokenDocument;

  const oldToken = beforeData.token;
  const newToken = afterData.token;

  // Exit if token hasn't changed
  if (oldToken === newToken) {
    console.log('Token unchanged, skipping update');
    return null;
  }

  try {
    // Get all documents that contain the old token
    const snapshot = await getFirestore(dbName)
      .collection('profiles')
      .where('followerTokens', 'array-contains', oldToken)
      .get();

    if (snapshot.empty) {
      console.log('No documents found containing the old token');
      return null;
    } else {
      console.log('Got a snapshot of followers that have the old token.');
    }

    // Batch updates for better performance and atomicity
    const batch = getFirestore(dbName).batch();
    console.log('Got a batch object from firestore.');

    for (const doc of snapshot.docs) {
      // Update the token in the list
      batch.update(doc.ref, {followerTokens: FieldValue.arrayRemove(oldToken)});
      batch.update(doc.ref, {followerTokens: FieldValue.arrayUnion(newToken)});
    }
    console.log('Added updates to batch.');

    await batch.commit();
    console.log(`Successfully updated ${snapshot.size} documents`);
  } catch (error) {
    console.error('Error updating tokens:', error);
  }
  return null;
}
