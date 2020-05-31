import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

import { updateConversation } from './conversations/on_user_leaving';
import { saveDetails } from './auth/on_first_sign_in';
import { createResizedPics } from './storage/on_profile_pic';
import { removeProfilePicFiles } from './profile/on_delete_profile_pic/on_delete_profile_pic';

// when a new account is created, add auth details to the database
export const saveDetailsOnFirstSignIn = functions.auth.user().onCreate(saveDetails);

// when a user leaves a conversation, update the conversation doc
export const updateConversationOnUserLeaving = functions.firestore.document('conversations/{conversationId}/leave/{userId}').onCreate(updateConversation);

// when a user uploads a profile pic, generate resized versions of various sizes for fast image serving 
export const generateResizedImages = functions.storage.bucket('crowdleague-profile-pics').object().onFinalize(createResizedPics);

// when a user deletes a profile pic, remove the files from storage (original and resized)
export const removeFilesOnProfilePicDelete = functions.firestore.document('leaguers/{userId}/profile_pics/{picId}').onDelete(removeProfilePicFiles);
