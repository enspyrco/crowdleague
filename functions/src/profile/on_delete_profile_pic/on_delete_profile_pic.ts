import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

import config from './config';
import * as logs from './logs';
import * as database from './database';

export async function removeProfilePicFiles(snapshot : functions.firestore.DocumentSnapshot, context : functions.EventContext) {

    ///////////////////////////////////////////////////////////////////////
    // Remove all files (original and resized) for a profile pic. 
    // 
    // Any failures (other than 404) are added to the db at: 
    //  -> "leaguers/${userId}/failed_profile_pics/${picId}"
    //
    // 404 errors are not considered failures as cloud functions can be called more than once 
    // so we need to allow for subsequent calls where files are already deleted 
    // 
    // Relevant references: 
    //  - https://firebase.google.com/docs/reference/admin/node 
    //  - https://googleapis.dev/nodejs/storage/latest/File.html#delete 
    //  
    //  Each call to delete() returns a DeleteBucketResponse, an array with an object at 
    //  position 0 that holds the full API response, but apparently the response is empty 
    //  if successful. 
    //  - https://googleapis.dev/nodejs/storage/latest/global.html#DeleteFileResponse
    //  - https://cloud.google.com/storage/docs/json_api/v1/objects/delete 
    //
    //  When using promises and await, errors need to be caught. Error responses are described here: 
    //  - https://cloud.google.com/storage/docs/json_api/v1/status-codes 
    //  
    ///////////////////////////////////////////////////////////////////////

    logs.start();

    try {
        const db = new database.FailedProfilePicDeletionEntry(context.params.userId,  context.params.picId);
        
        const filePath = context.params.userId + '/' + context.params.picId;
        logs.constructedFilePath(filePath);

        const bucket = admin.storage().bucket('crowdleague-profile-pics');

        const failures : any = {};
        let numFailures = 0;
        // delete original 
        try {
            await bucket.file(filePath).delete();
            logs.deletedFile(filePath);
        }
        catch(error) {
            logs.deletionFailed(filePath, error);
            if(error.code !== 404) { // if the file is not there, no need to add failure to db
                failures['original'] = JSON.parse(JSON.stringify(error));
                numFailures++;
            }
        }
        

        // Convert to a set to remove any duplicate sizes
        const imageSizes = new Set(config.imageSizes);
        // Iterate over the set and attempt to delete each image 
        for (const imageSize of imageSizes) {
            const resizedFilePath = filePath+'_'+imageSize;
            try {
                await bucket.file(resizedFilePath).delete();
                logs.deletedFile(resizedFilePath);
            }
            catch(error) {
                logs.deletionFailed(resizedFilePath, error);
                if(error.code !== 404) { // if the file is not there, no need to add failure to db
                    failures[imageSize] = JSON.parse(JSON.stringify(error));
                    numFailures++;
                }
            }
        }

        if (numFailures > 0) {
            logs.failed(numFailures, context.params.userId, context.params.picId);
            await db.failed(failures);
            return;
        }
        logs.complete();
        
    }
    catch(error) {
        console.error('Uncaught exception: '+error);
    }
}