import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { log } from "firebase-functions/logger";
import { HttpsError, onCall } from "firebase-functions/v2/https";

const MAX_ROSTER_SIZE = 15;

export const inviteToTeam = onCall(
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
      const inviteeId = request.data.inviteeId;
      const dbName = request.data.dbName;

      if (!teamId) {
        throw new HttpsError("invalid-argument", "teamId is required.");
      }
      if (!inviteeId) {
        throw new HttpsError("invalid-argument", "inviteeId is required.");
      }

      const db = getFirestore(dbName);

      // Verify user is captain
      const teamDoc = await db.collection("teams").doc(teamId).get();
      if (!teamDoc.exists) {
        throw new HttpsError("not-found", "Team not found.");
      }
      const teamData = teamDoc.data()!;

      if (teamData.captainId !== userId) {
        throw new HttpsError(
          "permission-denied",
          "Only the captain can invite players.",
        );
      }

      // Check roster limit
      if (teamData.memberIds && teamData.memberIds.length >= MAX_ROSTER_SIZE) {
        throw new HttpsError(
          "failed-precondition",
          `Team roster is full (${MAX_ROSTER_SIZE} max).`,
        );
      }

      // Check if player is already on team
      if (teamData.memberIds && teamData.memberIds.includes(inviteeId)) {
        throw new HttpsError(
          "already-exists",
          "Player is already on the team.",
        );
      }

      // Check for existing pending invite
      const existingInvite = await db
        .collection("teamInvites")
        .where("teamId", "==", teamId)
        .where("inviteeId", "==", inviteeId)
        .where("status", "==", "pending")
        .get();

      if (!existingInvite.empty) {
        throw new HttpsError(
          "already-exists",
          "An invite is already pending for this player.",
        );
      }

      log(`Captain ${userId} inviting ${inviteeId} to team ${teamId}`);

      const batch = db.batch();

      // Create team invite
      const inviteRef = db.collection("teamInvites").doc();
      batch.set(inviteRef, {
        teamId: teamId,
        teamName: teamData.name,
        inviterId: userId,
        inviteeId: inviteeId,
        status: "pending",
        createdAt: FieldValue.serverTimestamp(),
      });

      // Create notification for invitee
      const notificationRef = db.collection("notifications").doc();
      batch.set(notificationRef, {
        type: "team-invite",
        playerId: inviteeId,
        teamId: teamId,
        teamName: teamData.name,
        inviterId: userId,
        inviteId: inviteRef.id,
        viewed: false,
        opened: false,
        timestamp: FieldValue.serverTimestamp(),
      });

      await batch.commit();

      log(`Invite ${inviteRef.id} created successfully`);

      return { success: true, inviteId: inviteRef.id };
    } catch (e) {
      log(`Error in inviteToTeam: ${e}`);
      throw new HttpsError("aborted", `${e}`);
    }
  },
);
