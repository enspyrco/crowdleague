import {log} from "firebase-functions/logger";
import {FieldValue, getFirestore} from "firebase-admin/firestore";
import {getMessaging} from "firebase-admin/messaging";
import {onDocumentCreated} from "firebase-functions/v2/firestore";

export const notifyRequesteeOnFollowRequest = onDocumentCreated({
  document: "profiles/{requesterId}/follow-requests/{requesteeId}",
  database: "firestore-usa",
}, async (event) => {
  // Get the new checkin data
  const {params, data} = event;

  // Safely extract entry data
  if (!data) {
    console.log("No data in the event");
    return;
  }

  try {
    log(`requesteeId = ${params.requesteeId}, ` +
      `requesterId = ${params.requesterId}`);

    // Fetch the requestee's profile
    const dbRef = getFirestore("firestore-usa");

    // Add the requester id to the requestee's profile
    // so profile shows 'pending'
    await dbRef.doc(`profiles/${params.requesteeId}`).update({
      pendingFollowRequests: FieldValue.arrayUnion(params.requesterId),
    });
    log(`Added ${params.requesterId} to 'pendingFollowRequests' ` +
      `of profiles/${params.requesteeId}`);

    // Add a notification to the requestee's notifications list
    await dbRef.collection("profiles").doc(params.requesteeId)
      .collection("notifications").doc()
      .set({
        type: "follow-request",
        requesterId: params.requesterId,
        timestamp: FieldValue.serverTimestamp(),
        opened: false,
        viewed: false,
      });
    log(`Notification added to profiles/${params.requesteeId}/` +
      `notifications/${params.requesterId}`);

    // delete the doc that triggered the cloud function
    await dbRef.doc(`profiles/${params.requesterId}/` +
      `follow-requests/${params.requesteeId}`).delete();
    log(`profiles/${params.requesterId}/` +
      `follow-requests/${params.requesteeId} deleted`);

    const tokenDoc = await dbRef.doc(`fcmTokens/${params.requesteeId}`).get();
    const tokenDocData = tokenDoc.data();

    const profileDoc = await dbRef.doc(`profiles/${params.requesterId}`).get();
    const profileDocData = profileDoc.data();

    const message = {
      notification: {
        title: "Team Up?",
        body: `${profileDocData?.name} wants to team up with you`,
      },
      token: tokenDocData?.token,
    };

    // Send a message to the device
    const response = await getMessaging().send(message);
    log("Successfully sent message:", response);

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
