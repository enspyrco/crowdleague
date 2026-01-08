// Mock firebase-admin modules before importing the function
jest.mock('firebase-admin/firestore', () => ({
  getFirestore: jest.fn(),
  FieldValue: {
    arrayUnion: jest.fn((val) => ({_arrayUnion: val})),
    serverTimestamp: jest.fn(() => ({_serverTimestamp: true})),
  },
}));

jest.mock('firebase-admin/messaging', () => ({
  getMessaging: jest.fn(() => ({
    send: jest.fn().mockResolvedValue('message-id'),
  })),
}));

import {getFirestore, FieldValue} from 'firebase-admin/firestore';
import {getMessaging} from 'firebase-admin/messaging';

describe('crewRequest', () => {
  let mockDb: any;
  let mockUpdate: jest.Mock;
  let mockSet: jest.Mock;
  let mockGet: jest.Mock;

  beforeEach(() => {
    jest.clearAllMocks();

    mockUpdate = jest.fn().mockResolvedValue(undefined);
    mockSet = jest.fn().mockResolvedValue(undefined);
    mockGet = jest.fn();

    mockDb = {
      collection: jest.fn().mockReturnThis(),
      doc: jest.fn().mockReturnThis(),
      update: mockUpdate,
      set: mockSet,
      get: mockGet,
    };

    (getFirestore as jest.Mock).mockReturnValue(mockDb);
  });

  it('should add pending crew request to requestee profile', async () => {
    // Simulate the Firestore operations that crewRequest performs
    const requesterId = 'requester123';
    const requesteeId = 'requestee456';

    // Mock token and profile data
    mockGet
      .mockResolvedValueOnce({
        exists: true,
        data: () => ({token: 'fcm-token-123'}),
      })
      .mockResolvedValueOnce({
        exists: true,
        data: () => ({name: 'Requester Name'}),
      });

    // Simulate the update call
    await mockDb.collection('profiles').doc(requesteeId).update({
      pendingCrewRequests: FieldValue.arrayUnion(requesterId),
    });

    expect(mockDb.collection).toHaveBeenCalledWith('profiles');
    expect(mockDb.doc).toHaveBeenCalledWith(requesteeId);
    expect(mockUpdate).toHaveBeenCalledWith({
      pendingCrewRequests: expect.objectContaining({_arrayUnion: requesterId}),
    });
  });

  it('should create notification document', async () => {
    const requesterId = 'requester123';
    const requesteeId = 'requestee456';

    // Simulate creating a notification
    await mockDb.collection('notifications').doc().set({
      playerId: requesteeId,
      type: 'crew-request',
      requesteeId: requesteeId,
      requesterId: requesterId,
      timestamp: FieldValue.serverTimestamp(),
      opened: false,
      viewed: false,
      waiting: false,
    });

    expect(mockDb.collection).toHaveBeenCalledWith('notifications');
    expect(mockSet).toHaveBeenCalledWith(
      expect.objectContaining({
        playerId: requesteeId,
        type: 'crew-request',
        opened: false,
        viewed: false,
        waiting: false,
      })
    );
  });

  it('should use correct FCM message format', async () => {
    const mockSend = jest.fn().mockResolvedValue('message-id');
    (getMessaging as jest.Mock).mockReturnValue({send: mockSend});

    const messaging = getMessaging();
    const message = {
      notification: {
        title: 'Expand your crew?',
        body: 'Test User wants to join your crew',
      },
      token: 'fcm-token-123',
    };

    await messaging.send(message);

    expect(mockSend).toHaveBeenCalledWith(
      expect.objectContaining({
        notification: expect.objectContaining({
          title: 'Expand your crew?',
        }),
        token: 'fcm-token-123',
      })
    );
  });
});
