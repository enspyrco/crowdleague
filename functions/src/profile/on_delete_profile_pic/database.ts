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
        const data = {
            'picId': this.picId,
            'failures': failures
        };
        await db.collection(`users/${this.uid}/processing_failures`).add({
            'type': 'on_delete_profile_pic',
            'createdOn': admin.firestore.FieldValue.serverTimestamp,
            'message': JSON.stringify(data),
            'data': data
        });
    }
}