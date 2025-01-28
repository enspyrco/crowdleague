import {messaging} from 'firebase-admin';
import {FieldValue, getFirestore} from 'firebase-admin/firestore';
import {MulticastMessage} from 'firebase-admin/messaging';
import {log} from 'firebase-functions/logger';
import {https} from 'firebase-functions/v2';
import {HttpsError, onCall} from 'firebase-functions/v2/https';

export const sendMessageToParticipants = onCall(
  {
    cors: true,
    region: ['australia-southeast2', 'us-central1'],
  },
  async (request) => {
    try {
      if (!request.auth) {
        throw new HttpsError('unauthenticated', 'request.auth was undefined.');
      }

      const db = getFirestore(request.data.dbName);

      log(
        `senderId = ${request.data.senderId}, ` +
        `conversationId = ${request.data.conversationId}, ` +
        `message: ${request.data.message}`
      );

      // Get the conversation data
      const conversationSnapshot = await db.collection('conversations')
        .doc(`${request.data.conversationId}`).get();
      if (!conversationSnapshot.exists) {
        throw new HttpsError('not-found', 'Conversation snapshot ' +
          'did not exist.');
      }
      const conversationData = conversationSnapshot.data();
      if (!conversationData) {
        throw new HttpsError('not-found', 'Conversatiooon snapshot.data() ' +
          'was undefined.');
      }
      log('Got the conversation data');

      if (conversationData.participantIds.length > 500) {
        throw new https.HttpsError(
          'invalid-argument',
          'Maximum of 500 tokens can be retrieved in a single batch'
        );
      }

      // Add the message to the conversation
      await db.collection('conversations')
        .doc(request.data.conversationId)
        .collection('messages')
        .add({
          value: request.data.message,
          senderId: request.data.senderId,
          timestamp: FieldValue.serverTimestamp(),
          readBy: [request.data.senderId],
        });

      const tokensRef = db.collection('fcmTokens');

      // Batch get the documents
      const tokenDocs = await db.getAll(
        ...conversationData.participantIds.map((id : string) =>
          tokensRef.doc(id))
      );
      log('Batch retrieved the participant ids');

      const tokens: string[] = [];
      const missingDocIds: string[] = [];

      // Process results into tokens and missing
      tokenDocs.forEach((doc, index) => {
        const data = doc.data();
        if (!doc.exists || !data) {
          missingDocIds.push(conversationData.participantIds[index]);
        } else {
          tokens.push(data.token);
        }
      });
      log(`Processed the results, missing docs: ${missingDocIds}`);

      // Create the message
      const message: MulticastMessage = {
        notification: {
          title: request.data.senderName,
          body: request.data.message,
        },
        data: {senderId: request.data.senderId, message: request.data.message},
        tokens: tokens,
      };

      // Send the message
      const response = await messaging().sendEachForMulticast(message);
      log(`Sent the message, response: ${response}`);

      // we were getting a 409 error in the logs but all logs in the code were
      // being printed so I've commented out the return statement.
      // // Return the response
      // return {
      //   successCount: response.successCount,
      //   failureCount: response.failureCount,
      //   failedTokens: response.responses
      //     .map((resp, idx) => (!resp.success ?
      //       conversationData.participantTokens[idx] : null))
      //     .filter((token): token is string => token !== null),
      // };
    } catch (e) {
      throw new HttpsError('aborted', `${e}.`);
    }
  });
