import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
const db = admin.firestore();
import { DeleteFileResponse } from 'firebase-admin/node_modules/@google-cloud/storage';

export async function removeProfilePicFiles(snapshot : functions.firestore.DocumentSnapshot, context : functions.EventContext) {

    ///////////////////////////////////////////////////////////////////////
    // remove the files (original and resized)
    ///////////////////////////////////////////////////////////////////////

    try {
        const filePath = context.params.userId + '/' + context.params.picId;
        const bucket = admin.storage().bucket('gs://crowdleague-profile-pics');
        
        const sizes = new Map<string, string>();
        sizes.set('original', ''); 
        sizes.set('50', '_50x50');
        sizes.set('100', '_100x100');
        sizes.set('200', '_200x200');
        sizes.set('500', '_500x500');

        // const tasks: Promise<DeleteFileResponse>[] = [];
        const badResultsMap = new Map<string, DeleteFileResponse>();
        
        for(const key in sizes) {
            const result = await bucket.file(filePath+sizes.get(key)).delete() as DeleteFileResponse;
            if(result[0].success === false) {
                badResultsMap.set(key, result);
            }
        }
        // tasks.push(bucket.file(filePath).delete());
        // tasks.push(bucket.file(filePath+'_50x50').delete());
        // tasks.push(bucket.file(filePath+'_100x100').delete());
        // tasks.push(bucket.file(filePath+'_200x200').delete());
        // tasks.push(bucket.file(filePath+'_500x500').delete());

        // const results = await Promise.all(tasks);
        
        // const failed = results.some((result) => result[0].success === false);

        if (badResultsMap.size > 0) {
            // if there was a problem, add the doc back with an error entry 
            try {
                await db.doc(`leaguers/${context.params.userId}/profilePics/${context.params.picId}`).set({'error': badResultsMap});
            }
            catch(error) {
                console.error(error);
            }
        }
    }
    catch(error) {
        console.error(error);
        
    }
}