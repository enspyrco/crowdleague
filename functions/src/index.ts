// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
import * as functions from 'firebase-functions';

// The Firebase Admin SDK to access the Firestore.
import * as admin from 'firebase-admin';

admin.initializeApp();
const db = admin.firestore();

// The user object here is a:
// https://firebase.google.com/docs/reference/admin/node/admin.auth.UserRecord 
export const saveDetailsOnFirstSignIn = functions.auth.user().onCreate(async (user) => {
    // add all auth data to the user doc 
    await db.doc('/users/'+user.uid).set({
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

    // add relevant data to the leaguer doc
    await db.doc('/leaguers/'+user.uid).set({
        displayName: user.displayName ?? null,
        photoURL: user.photoURL ?? null,
    });
});

// when a user leaves a conversation, update the conversation doc
export const updateConversationOnUserLeaving = functions.firestore.document('conversations/{conversationId}/leave/{userId}').onCreate(async (snapshot, context) => {

    ///////////////////////////////////////////////////////////////////////
    // remove the user from the conversation 
    ///////////////////////////////////////////////////////////////////////

    // get the document data 
    const conversationDocRef = db.collection('conversations').doc(context.params.conversationId);
    const conversationData = (await conversationDocRef.get()).data();

    if(conversationData === undefined) {
        console.error("(await db.collection('conversations').doc(context.params..conversationId).get()).data() was undefined");
        return;
    }

    // find the index of the leaving user and delete their entry in each list
    const index = conversationData.uids.indexOf(context.params.userId);
    conversationData.uids.splice(index, 1);
    conversationData.photoURLs.splice(index, 1);
    conversationData.displayNames.splice(index, 1);

    // push the promise returned by the set 
    await conversationDocRef.set(conversationData);

    ///////////////////////////////////////////////////////////////////////
    // add a message that the user left 
    ///////////////////////////////////////////////////////////////////////

    // add a message indicating user has left the conversation
    await db.collection('conversations/'+context.params.conversationId+'/messages').add({
        authorId: context.params.userId,
        text: 'And... I\'m out!',
        timestamp: admin.firestore.FieldValue.serverTimestamp()
    });
    
});