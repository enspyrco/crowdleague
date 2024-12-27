import {log} from "firebase-functions/logger";
import * as admin from "firebase-admin";
import {FieldValue,getFirestore} from "firebase-admin/firestore";
import {onDocumentCreated} from "firebase-functions/v2/firestore";

admin.initializeApp();

exports.notifyRequesteeOnTeamRequest = onDocumentCreated({
  document: "profiles/{requesterId}/team-requests/{requesteeId}",
  database: "firestore-usa"
}, async (event) => {
  // Get the new checkin data
  const {params, data} = event;

  // Safely extract entry data
  if (!data) {
    console.log("No data in the event");
    return;
  }

  try {
    // Fetch the requestee's profile
    const requesteeProfileRef = getFirestore("firestore-usa")
      .doc(`profiles/${params.requesteeId}`);

    // Add the requester id to the requestee's profile
    await requesteeProfileRef.update({
      pendingTeamRequests: FieldValue.arrayUnion(params.requesterId),
    });

    log(`Added ${params.requesterId} to 'pendingTeamRequests' of profiles/${params.requesteeId}`)

    // // Batch notifications with more efficient processing
    // const notificationTasks = friendIds.map(async (friendId: string) => {
    //   // Fetch friend's token
    //   const tokenDoc = await admin.firestore()
    //     .collection("user_tokens")
    //     .doc(friendId)
    //     .get();

    //   const friendToken = tokenDoc.data()?.token;

    //   if (friendToken) {
    //     const message = {
    //       notification: {
    //         title: "New Checkin",
    //         body: "Your friend added a new entry!",
    //       },
    //       token: friendToken,
    //       data: {
    //         type: "new_entry",
    //         venueId: venueId,
    //         checkingInId: newCheckin.uid,
    //       },
    //     };

    //     try {
    //       await admin.messaging().send(message);
    //       console.log(`Notification sent to friend: ${friendId}`);
    //     } catch (error) {
    //       console.error("Messaging error:", error);
    //     }
    //   }
    // });

    // // Wait for all notifications to complete
    // await Promise.all(notificationTasks);
  } catch (error) {
    console.error("Function execution error:", error);
  }
});
