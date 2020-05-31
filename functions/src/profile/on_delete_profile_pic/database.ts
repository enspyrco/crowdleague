import * as admin from 'firebase-admin';
const db = admin.firestore();

export class FailedProfilePicDeletionEntry {
    uid: string;
    picId : string;

    constructor(userId: string, profilePicId: string) {
        this.uid = userId;
        this.picId = profilePicId;
    }
    async failed(failures: any) {
        await db.doc(`leaguers/${this.uid}/failed_profile_pics/${this.picId}`).set({
            'failures' : failures
        });
    }
}