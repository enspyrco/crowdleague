import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { log } from "firebase-functions/logger";
import { HttpsError, onCall } from "firebase-functions/v2/https";

export const declineTeamInvite = onCall(
  {
    cors: true,
    region: "us-central1",
  },
  async (request) => {
    try {
      if (!request.auth) {
        throw new HttpsError("unauthenticated", "User must be authenticated.");
      }

      const userId = request.auth.uid;
      const inviteId = request.data.inviteId;
      const dbName = request.data.dbName;

      if (!inviteId) {
        throw new HttpsError("invalid-argument", "inviteId is required.");
      }

      const db = getFirestore(dbName);

      // Get and validate invite
      const inviteDoc = await db.collection("teamInvites").doc(inviteId).get();
      if (!inviteDoc.exists) {
        throw new HttpsError("not-found", "Invite not found.");
      }
      const inviteData = inviteDoc.data()!;

      if (inviteData.inviteeId !== userId) {
        throw new HttpsError(
          "permission-denied",
          "This invite is not for you.",
        );
      }
      if (inviteData.status !== "pending") {
        throw new HttpsError(
          "failed-precondition",
          "Invite has already been processed.",
        );
      }

      log(`User ${userId} declining invite ${inviteId}`);

      const batch = db.batch();

      // Update invite status
      batch.update(inviteDoc.ref, { status: "declined" });

      // Optionally notify captain (low priority)
      const notificationRef = db.collection("notifications").doc();
      batch.set(notificationRef, {
        type: "team-invite-declined",
        playerId: inviteData.inviterId,
        teamId: inviteData.teamId,
        teamName: inviteData.teamName,
        inviteeId: userId,
        viewed: false,
        opened: false,
        timestamp: FieldValue.serverTimestamp(),
      });

      await batch.commit();

      log(`Invite ${inviteId} declined`);

      return { success: true };
    } catch (e) {
      log(`Error in declineTeamInvite: ${e}`);
      throw new HttpsError("aborted", `${e}`);
    }
  },
);
