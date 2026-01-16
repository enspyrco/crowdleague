import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { log } from "firebase-functions/logger";
import { HttpsError, onCall } from "firebase-functions/v2/https";

export const removeFromTeam = onCall(
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
      const playerId = request.data.playerId;
      const dbName = request.data.dbName;

      if (!teamId) {
        throw new HttpsError("invalid-argument", "teamId is required.");
      }
      if (!playerId) {
        throw new HttpsError("invalid-argument", "playerId is required.");
      }

      const db = getFirestore(dbName);

      // Get team
      const teamDoc = await db.collection("teams").doc(teamId).get();
      if (!teamDoc.exists) {
        throw new HttpsError("not-found", "Team not found.");
      }
      const teamData = teamDoc.data()!;

      // Only captain can remove members
      if (teamData.captainId !== userId) {
        throw new HttpsError(
          "permission-denied",
          "Only the captain can remove members.",
        );
      }

      // Cannot remove yourself (captain) - use deleteTeam instead
      if (playerId === userId) {
        throw new HttpsError(
          "failed-precondition",
          "Captain cannot remove themselves. Transfer captaincy first.",
        );
      }

      // Check player is a member
      if (!teamData.memberIds || !teamData.memberIds.includes(playerId)) {
        throw new HttpsError(
          "failed-precondition",
          "Player is not a member of this team.",
        );
      }

      log(`Captain ${userId} removing ${playerId} from team ${teamId}`);

      const batch = db.batch();

      // Remove player from team
      batch.update(teamDoc.ref, {
        memberIds: FieldValue.arrayRemove(playerId),
      });

      // Remove team from player's profile
      batch.update(db.collection("profiles").doc(playerId), {
        teamIds: FieldValue.arrayRemove(teamId),
      });

      // Notify removed player
      const notificationRef = db.collection("notifications").doc();
      batch.set(notificationRef, {
        type: "team-removed",
        playerId: playerId,
        teamId: teamId,
        teamName: teamData.name,
        viewed: false,
        opened: false,
        timestamp: FieldValue.serverTimestamp(),
      });

      await batch.commit();

      log(`Player ${playerId} removed from team ${teamId}`);

      return { success: true };
    } catch (e) {
      log(`Error in removeFromTeam: ${e}`);
      throw new HttpsError("aborted", `${e}`);
    }
  },
);
