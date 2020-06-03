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
    async failed(failures: any[]) {
        const data = {
            'picId': this.picId,
            'failures': failures
        };
        await db.collection(`users/${this.uid}/processing_failures`).add({
            'type': 'on_profile_pic',
            'createdOn': admin.firestore.FieldValue.serverTimestamp,
            'message': JSON.stringify(data),
            'data': data
        });
    }
}