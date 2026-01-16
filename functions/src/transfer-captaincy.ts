import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { log } from "firebase-functions/logger";
import { HttpsError, onCall } from "firebase-functions/v2/https";

export const transferCaptaincy = onCall(
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
      const newCaptainId = request.data.newCaptainId;
      const dbName = request.data.dbName;

      if (!teamId) {
        throw new HttpsError("invalid-argument", "teamId is required.");
      }
      if (!newCaptainId) {
        throw new HttpsError("invalid-argument", "newCaptainId is required.");
      }

      const db = getFirestore(dbName);

      // Get team
      const teamDoc = await db.collection("teams").doc(teamId).get();
      if (!teamDoc.exists) {
        throw new HttpsError("not-found", "Team not found.");
      }
      const teamData = teamDoc.data()!;

      // Only current captain can transfer
      if (teamData.captainId !== userId) {
        throw new HttpsError(
          "permission-denied",
          "Only the captain can transfer captaincy.",
        );
      }

      // Cannot transfer to yourself
      if (newCaptainId === userId) {
        throw new HttpsError(
          "invalid-argument",
          "You are already the captain.",
        );
      }

      // New captain must be a team member
      if (!teamData.memberIds || !teamData.memberIds.includes(newCaptainId)) {
        throw new HttpsError(
          "failed-precondition",
          "New captain must be a team member.",
        );
      }

      log(
        `Captain ${userId} transferring captaincy ` +
          `to ${newCaptainId} for team ${teamId}`,
      );

      const batch = db.batch();

      // Update team captain
      batch.update(teamDoc.ref, {
        captainId: newCaptainId,
      });

      // Notify new captain
      const notificationRef = db.collection("notifications").doc();
      batch.set(notificationRef, {
        type: "team-captaincy-received",
        playerId: newCaptainId,
        teamId: teamId,
        teamName: teamData.name,
        previousCaptainId: userId,
        viewed: false,
        opened: false,
        timestamp: FieldValue.serverTimestamp(),
      });

      await batch.commit();

      log(`Captaincy transferred to ${newCaptainId} for team ${teamId}`);

      return { success: true };
    } catch (e) {
      log(`Error in transferCaptaincy: ${e}`);
      throw new HttpsError("aborted", `${e}`);
    }
  },
);
