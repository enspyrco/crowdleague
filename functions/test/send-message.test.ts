// Mock firebase-admin modules
jest.mock('firebase-admin/firestore', () => ({
  getFirestore: jest.fn(),
  FieldValue: {
    serverTimestamp: jest.fn(() => ({_serverTimestamp: true})),
  },
}));

jest.mock('firebase-admin', () => ({
  messaging: jest.fn(() => ({
    sendEachForMulticast: jest.fn().mockResolvedValue({
      successCount: 2,
      failureCount: 0,
    }),
  })),
}));

import {getFirestore, FieldValue} from 'firebase-admin/firestore';
import {messaging} from 'firebase-admin';

describe('sendMessageToParticipants', () => {
  let mockDb: any;
  let mockGet: jest.Mock;
  let mockAdd: jest.Mock;
  let mockGetAll: jest.Mock;

  beforeEach(() => {
    jest.clearAllMocks();

    mockGet = jest.fn();
    mockAdd = jest.fn().mockResolvedValue({id: 'newMessageId'});
    mockGetAll = jest.fn();

    mockDb = {
      collection: jest.fn().mockReturnThis(),
      doc: jest.fn().mockReturnThis(),
      get: mockGet,
      add: mockAdd,
      getAll: mockGetAll,
    };

    (getFirestore as jest.Mock).mockReturnValue(mockDb);
  });

  it('should add message to conversation', async () => {
    const conversationId = 'conv123';
    const senderId = 'sender123';
    const messageText = 'Hello everyone!';

    await mockDb
      .collection('conversations')
      .doc(conversationId)
      .collection('messages')
      .add({
        value: messageText,
        senderId: senderId,
        timestamp: FieldValue.serverTimestamp(),
        readBy: [senderId],
      });

    expect(mockDb.collection).toHaveBeenCalledWith('conversations');
    expect(mockDb.doc).toHaveBeenCalledWith(conversationId);
    expect(mockAdd).toHaveBeenCalledWith(
      expect.objectContaining({
        value: messageText,
        senderId: senderId,
        readBy: [senderId],
      })
    );
  });

  it('should retrieve conversation data', async () => {
    const participantIds = ['user1', 'user2', 'user3'];

    mockGet.mockResolvedValue({
      exists: true,
      data: () => ({participantIds}),
    });

    const result = await mockDb
      .collection('conversations')
      .doc('conv123')
      .get();

    expect(result.exists).toBe(true);
    expect(result.data().participantIds).toEqual(participantIds);
  });

  it('should batch retrieve FCM tokens', async () => {
    const participantIds = ['user1', 'user2'];
    const tokensRef = mockDb.collection('fcmTokens');

    mockGetAll.mockResolvedValue([
      {exists: true, data: () => ({token: 'token1'})},
      {exists: true, data: () => ({token: 'token2'})},
    ]);

    const tokenDocs = await mockDb.getAll(
      ...participantIds.map((id: string) => tokensRef.doc(id))
    );

    expect(tokenDocs.length).toBe(2);
    expect(tokenDocs[0].data().token).toBe('token1');
    expect(tokenDocs[1].data().token).toBe('token2');
  });

  it('should handle missing FCM tokens gracefully', async () => {
    const participantIds = ['user1', 'user2', 'user3'];

    mockGetAll.mockResolvedValue([
      {exists: true, data: () => ({token: 'token1'})},
      {exists: false, data: () => undefined}, // Missing token
      {exists: true, data: () => ({token: 'token3'})},
    ]);

    const tokenDocs = await mockDb.getAll();

    const tokens: string[] = [];
    const missingDocIds: string[] = [];

    tokenDocs.forEach((doc: any, index: number) => {
      const data = doc.data();
      if (!doc.exists || !data) {
        missingDocIds.push(participantIds[index]);
      } else {
        tokens.push(data.token);
      }
    });

    expect(tokens).toEqual(['token1', 'token3']);
    expect(missingDocIds).toEqual(['user2']);
  });

  it('should create correct multicast message format', async () => {
    const mockSendMulticast = jest.fn().mockResolvedValue({
      successCount: 2,
      failureCount: 0,
    });
    (messaging as jest.Mock).mockReturnValue({
      sendEachForMulticast: mockSendMulticast,
    });

    const message = {
      notification: {
        title: 'Sender Name',
        body: 'Hello everyone!',
      },
      data: {senderId: 'sender123', message: 'Hello everyone!'},
      tokens: ['token1', 'token2'],
    };

    const msgInstance = messaging();
    await msgInstance.sendEachForMulticast(message);

    expect(mockSendMulticast).toHaveBeenCalledWith(
      expect.objectContaining({
        notification: expect.objectContaining({
          title: 'Sender Name',
          body: 'Hello everyone!',
        }),
        tokens: ['token1', 'token2'],
      })
    );
  });

  it('should include senderId in readBy when adding message', async () => {
    const senderId = 'sender123';

    await mockDb.collection('conversations').doc('conv123')
      .collection('messages')
      .add({
        value: 'Test message',
        senderId: senderId,
        timestamp: FieldValue.serverTimestamp(),
        readBy: [senderId],
      });

    expect(mockAdd).toHaveBeenCalledWith(
      expect.objectContaining({
        readBy: [senderId],
      })
    );
  });
});
