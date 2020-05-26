import * as admin from 'firebase-admin';
const db = admin.firestore();

export class ProcessingEntry {
    uid: string;
    picId : string;

    constructor(userId: string, profilePicId: string) {
        this.uid = userId;
        this.picId = profilePicId;
    }
    async complete() {
        await db.doc(`leaguers/${this.uid}/profile_pics/${this.picId}`).set({
            'addedOn' : admin.firestore.FieldValue.serverTimestamp(),
        });
        await db.doc(`leaguers/${this.uid}`).update({
            'photoURL' : `https://storage.googleapis.com/crowdleague-profile-pics/${this.uid}/${this.picId}_200x200`,
        });
    }
    async failed() {
        await db.doc(`leaguers/${this.uid}/failed_profile_pics/${this.picId}`).set({
            'message' : 'The resize failed, see cloud function logs for details.'
        });
    }
}