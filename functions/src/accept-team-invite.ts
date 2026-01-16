import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { log } from "firebase-functions/logger";
import { HttpsError, onCall } from "firebase-functions/v2/https";

const MAX_ROSTER_SIZE = 15;

export const acceptTeamInvite = onCall(
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

      // Check team still exists and has room
      const teamDoc = await db.collection("teams").doc(inviteData.teamId).get();
      if (!teamDoc.exists) {
        throw new HttpsError("not-found", "Team no longer exists.");
      }
      const teamData = teamDoc.data()!;

      if (teamData.memberIds && teamData.memberIds.length >= MAX_ROSTER_SIZE) {
        throw new HttpsError("failed-precondition", "Team roster is now full.");
      }

      log(
        `User ${userId} accepting invite ${inviteId} ` +
          `to team ${inviteData.teamId}`,
      );

      const batch = db.batch();

      // Update invite status
      batch.update(inviteDoc.ref, { status: "accepted" });

      // Add user to team
      batch.update(teamDoc.ref, {
        memberIds: FieldValue.arrayUnion(userId),
      });

      // Add team to user's profile
      batch.update(db.collection("profiles").doc(userId), {
        teamIds: FieldValue.arrayUnion(inviteData.teamId),
      });

      // Notify captain that invite was accepted
      const notificationRef = db.collection("notifications").doc();
      batch.set(notificationRef, {
        type: "team-invite-accepted",
        playerId: inviteData.inviterId,
        teamId: inviteData.teamId,
        teamName: inviteData.teamName,
        inviteeId: userId,
        viewed: false,
        opened: false,
        timestamp: FieldValue.serverTimestamp(),
      });

      await batch.commit();

      log(`User ${userId} successfully joined team ${inviteData.teamId}`);

      return { success: true };
    } catch (e) {
      log(`Error in acceptTeamInvite: ${e}`);
      throw new HttpsError("aborted", `${e}`);
    }
  },
);
