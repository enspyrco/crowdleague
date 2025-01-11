import {HttpsError} from 'firebase-functions/https';

/**
 * Retrieve the snapshot for the reference.
 * @param {FirebaseFirestore.DocumentReference} ref The document reference.
 * @return {FirebaseFirestore.DocumentData} The data from the document snapshot.
 */
export async function getDocumentSnapshot(
  ref : FirebaseFirestore.DocumentReference) :
  Promise<FirebaseFirestore.DocumentData | undefined> {
  const snapshot = await ref.get();
  if (!snapshot.exists) {
    throw new HttpsError('not-found', `${ref.id} snapshot did not exist.`);
  }
  const snapshotData = snapshot.data();
  if (!snapshotData) {
    throw new HttpsError('not-found',
      `${ref.id} snapshot.data() was undefined.`);
  }

  return snapshotData;
}
