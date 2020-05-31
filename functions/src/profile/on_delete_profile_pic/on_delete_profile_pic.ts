import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { DeleteFileResponse } from 'firebase-admin/node_modules/@google-cloud/storage';

import config from './config';
import * as logs from './logs';
import * as database from './database';

export async function removeProfilePicFiles(snapshot : functions.firestore.DocumentSnapshot, context : functions.EventContext) {

    ///////////////////////////////////////////////////////////////////////
    // remove the files (original and resized)
    // 
    // see: 
    //  - https://firebase.google.com/docs/reference/admin/node 
    //  - https://googleapis.dev/nodejs/storage/latest/File.html#delete 
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
        const originalResponse : DeleteFileResponse = await bucket.file(filePath).delete();
        logs.deleteFileResponse('original', originalResponse);
        if(originalResponse[0].success === false) {
            failures['original'] = originalResponse;
            numFailures++;
        }

        // Convert to a set to remove any duplicate sizes
        const imageSizes = new Set(config.imageSizes);
        imageSizes.forEach(async (size) => {
            const sizeResponse : DeleteFileResponse = await bucket.file(filePath+'_'+size).delete();
            logs.deleteFileResponse(size, sizeResponse);
            if(sizeResponse[0].success === false) {
                failures[size] = sizeResponse;
                numFailures++;
            }
        });

        if (numFailures > 0) {
            logs.failed(failures);
            await db.failed(failures);
            return;
        }
        logs.complete();
        
    }
    catch(error) {
        console.error(error);
        
    }
}