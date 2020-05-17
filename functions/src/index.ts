// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
import * as functions from 'firebase-functions';

// The Firebase Admin SDK to access the Firestore.
import * as admin from 'firebase-admin';

admin.initializeApp();
const db = admin.firestore();

// The user object here is a:
// https://firebase.google.com/docs/reference/admin/node/admin.auth.UserRecord 
export const saveDetailsOnFirstSignIn = functions.auth.user().onCreate((user) => {
    return db.doc('/users/'+user.uid).set({
        uid: user.uid,
        displayName: user.displayName ?? null,
        email: user.email ?? null,
        photoURL: user.photoURL ?? null, 
        phoneNumber: user.phoneNumber ?? null,
        providerData: user.providerData.map(info => ({
            displayName: info.displayName ?? null,
            email: info.email ?? null,
            phoneNumber: info.phoneNumber ?? null,
            photoURL: info.photoURL ?? null,
            providerId: info.providerId,
            uid: info.uid
        }))
    });
});
