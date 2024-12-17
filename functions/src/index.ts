/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
import * as admin from "firebase-admin";
import {
  onDocumentCreated,
} from "firebase-functions/v2/firestore";

// Initialize Firebase Admin SDK
admin.initializeApp();

exports.notifyFriendsOnNewCheckin = onDocumentCreated(
  "checkins/{venueId}", async (event) => {
    // Get the new checkin data
    const {params, data} = event;

    // Safely extract entry data
    if (!data) {
      console.log("No data in the event");
      return;
    }

    const newCheckin = data.data();

    const venueId = params.venueId;

    try {
      // Fetch the author's friends
      const userRef = admin.firestore().collection("users").doc(newCheckin.uid);
      const userDoc = await userRef.get();
      const friendIds = userDoc.data()?.friends || [];

      // Batch notifications with more efficient processing
      const notificationTasks = friendIds.map(async (friendId: string) => {
        // Fetch friend's token
        const tokenDoc = await admin.firestore()
          .collection("user_tokens")
          .doc(friendId)
          .get();

        const friendToken = tokenDoc.data()?.token;

        if (friendToken) {
          const message = {
            notification: {
              title: "New Checkin",
              body: "Your friend added a new entry!",
            },
            token: friendToken,
            data: {
              type: "new_entry",
              venueId: venueId,
              checkingInId: newCheckin.uid,
            },
          };

          try {
            await admin.messaging().send(message);
            console.log(`Notification sent to friend: ${friendId}`);
          } catch (error) {
            console.error("Messaging error:", error);
          }
        }
      });

      // Wait for all notifications to complete
      await Promise.all(notificationTasks);
    } catch (error) {
      console.error("Function execution error:", error);
    }
  });
