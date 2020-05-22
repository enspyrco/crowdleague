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
        await db.doc(`leaguers/${this.uid}/processing/${this.picId}`).set({
            'complete' : true
        });
    }
    async failed() {
        await db.doc(`leaguers/${this.uid}/processing/${this.picId}`).set({
            'failed' : true
        });
    }
}