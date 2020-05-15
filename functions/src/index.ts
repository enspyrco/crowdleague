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

// when a conversation is created, add a conversation-summary to each participant at user/{uid}/conversation-summaries
export const addConversationsToUsers = functions.firestore.document('conversations/{conversationId}').onCreate((snapshot, context) => {

    const docData = snapshot.data();

    if(docData == undefined) {
        console.error('conversations/'+context.params.conversationId+' could not be read.');
        return;
    }

    var i;
    const promises = [];
    for(i = 0; i < docData.uids.length; i++) {
        const uid = docData.uids[i];
        const promise = db.collection('users/'+uid+'/conversation-summaries')
            .add({  conversationId: snapshot.id, 
                    uids: docData.uids, 
                    displayNames: docData.displayNames, 
                    photoURLs: docData.photoURLs
                });
        promises.push(promise);
    }

    return promises;

});