import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { log } from "firebase-functions/logger";
import { HttpsError, onCall } from "firebase-functions/v2/https";

export const deleteTeam = onCall(
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
      const teamId = request.data.teamId;
      const dbName = request.data.dbName;

      if (!teamId) {
        throw new HttpsError("invalid-argument", "teamId is required.");
      }

      const db = getFirestore(dbName);

      // Get team
      const teamDoc = await db.collection("teams").doc(teamId).get();
      if (!teamDoc.exists) {
        throw new HttpsError("not-found", "Team not found.");
      }
      const teamData = teamDoc.data()!;

      // Only captain can delete
      if (teamData.captainId !== userId) {
        throw new HttpsError(
          "permission-denied",
          "Only the captain can delete the team.",
        );
      }

      log(`Captain ${userId} deleting team ${teamId}`);

      const batch = db.batch();

      // Remove team from all members' profiles
      const memberIds = teamData.memberIds || [];
      for (const memberId of memberIds) {
        const profileRef = db.collection("profiles").doc(memberId);
        batch.update(profileRef, {
          teamIds: FieldValue.arrayRemove(teamId),
        });

        // Notify members (except captain) that team was deleted
        if (memberId !== userId) {
          const notificationRef = db.collection("notifications").doc();
          batch.set(notificationRef, {
            type: "team-deleted",
            playerId: memberId,
            teamId: teamId,
            teamName: teamData.name,
            viewed: false,
            opened: false,
            timestamp: FieldValue.serverTimestamp(),
          });
        }
      }

      // Delete all pending invites for this team
      const pendingInvites = await db
        .collection("teamInvites")
        .where("teamId", "==", teamId)
        .where("status", "==", "pending")
        .get();

      for (const invite of pendingInvites.docs) {
        batch.delete(invite.ref);
      }

      // Delete the team
      batch.delete(teamDoc.ref);

      await batch.commit();

      log(`Team ${teamId} deleted successfully`);

      return { success: true };
    } catch (e) {
      log(`Error in deleteTeam: ${e}`);
      throw new HttpsError("aborted", `${e}`);
    }
  },
);
