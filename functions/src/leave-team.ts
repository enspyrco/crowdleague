import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { log } from "firebase-functions/logger";
import { HttpsError, onCall } from "firebase-functions/v2/https";

export const leaveTeam = onCall(
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

      // Captain cannot leave - must delete team or transfer captaincy first
      if (teamData.captainId === userId) {
        throw new HttpsError(
          "failed-precondition",
          "Captain cannot leave. Delete the team or transfer captaincy first.",
        );
      }

      // Check user is a member
      if (!teamData.memberIds || !teamData.memberIds.includes(userId)) {
        throw new HttpsError(
          "failed-precondition",
          "You are not a member of this team.",
        );
      }

      log(`User ${userId} leaving team ${teamId}`);

      const batch = db.batch();

      // Remove user from team
      batch.update(teamDoc.ref, {
        memberIds: FieldValue.arrayRemove(userId),
      });

      // Remove team from user's profile
      batch.update(db.collection("profiles").doc(userId), {
        teamIds: FieldValue.arrayRemove(teamId),
      });

      await batch.commit();

      log(`User ${userId} successfully left team ${teamId}`);

      return { success: true };
    } catch (e) {
      log(`Error in leaveTeam: ${e}`);
      throw new HttpsError("aborted", `${e}`);
    }
  },
);
