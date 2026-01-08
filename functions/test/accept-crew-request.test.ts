// Mock firebase-admin modules
jest.mock('firebase-admin/firestore', () => ({
  getFirestore: jest.fn(),
  FieldValue: {
    arrayUnion: jest.fn((val) => ({_arrayUnion: val})),
    arrayRemove: jest.fn((val) => ({_arrayRemove: val})),
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

describe('acceptCrewRequest', () => {
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

  it('should remove pending crew request and add to crewIds', async () => {
    const requesterId = 'requester123';
    const requesteeId = 'requestee456';

    // Remove pending request
    await mockDb.collection('profiles').doc(requesteeId).update({
      pendingCrewRequests: FieldValue.arrayRemove(requesterId),
    });

    expect(mockUpdate).toHaveBeenCalledWith({
      pendingCrewRequests: expect.objectContaining({_arrayRemove: requesterId}),
    });

    // Add to crew
    await mockDb.collection('profiles').doc(requesteeId).update({
      crewIds: FieldValue.arrayUnion(requesterId),
    });

    expect(mockUpdate).toHaveBeenCalledWith({
      crewIds: expect.objectContaining({_arrayUnion: requesterId}),
    });
  });

  it('should add both users to each other\'s crewIds', async () => {
    const requesterId = 'requester123';
    const requesteeId = 'requestee456';

    // Add requester to requestee's crew
    await mockDb.collection('profiles').doc(requesteeId).update({
      crewIds: FieldValue.arrayUnion(requesterId),
    });

    // Add requestee to requester's crew
    await mockDb.collection('profiles').doc(requesterId).update({
      crewIds: FieldValue.arrayUnion(requesteeId),
    });

    expect(mockUpdate).toHaveBeenCalledTimes(2);
  });

  it('should update notification type to crew-accepted', async () => {
    const notificationId = 'notif123';

    await mockDb.collection('notifications').doc(notificationId).update({
      type: 'crew-accepted',
      waiting: false,
      viewed: false,
    });

    expect(mockDb.collection).toHaveBeenCalledWith('notifications');
    expect(mockDb.doc).toHaveBeenCalledWith(notificationId);
    expect(mockUpdate).toHaveBeenCalledWith({
      type: 'crew-accepted',
      waiting: false,
      viewed: false,
    });
  });

  it('should create crew-accepted notification for requester', async () => {
    const requesterId = 'requester123';
    const requesteeId = 'requestee456';

    await mockDb.collection('notifications').doc().set({
      playerId: requesterId,
      type: 'crew-accepted',
      requesteeId: requesterId,
      requesterId: requesteeId,
      timestamp: FieldValue.serverTimestamp(),
      opened: false,
      viewed: false,
      waiting: false,
    });

    expect(mockSet).toHaveBeenCalledWith(
      expect.objectContaining({
        playerId: requesterId,
        type: 'crew-accepted',
      })
    );
  });

  it('should add follower ids to both profiles', async () => {
    const requesterId = 'requester123';
    const requesteeId = 'requestee456';

    // Add to requestee's followers
    await mockDb.collection('profiles').doc(requesteeId).set(
      {followerIds: FieldValue.arrayUnion(requesterId)},
      {merge: true}
    );

    // Add to requester's followers
    await mockDb.collection('profiles').doc(requesterId).set(
      {followerIds: FieldValue.arrayUnion(requesteeId)},
      {merge: true}
    );

    expect(mockSet).toHaveBeenCalledWith(
      expect.objectContaining({
        followerIds: expect.objectContaining({_arrayUnion: requesterId}),
      }),
      {merge: true}
    );
  });

  it('should send FCM messages to both users', async () => {
    const mockSend = jest.fn().mockResolvedValue('message-id');
    (getMessaging as jest.Mock).mockReturnValue({send: mockSend});

    const messaging = getMessaging();

    // Message to requestee
    await messaging.send({
      notification: {
        title: 'Your crew is growing',
        body: 'Requester Name is now part of your crew.',
      },
      token: 'requestee-token',
    });

    // Message to requester
    await messaging.send({
      notification: {
        title: 'Your crew is growing',
        body: 'Requestee Name is now part of your crew.',
      },
      token: 'requester-token',
    });

    expect(mockSend).toHaveBeenCalledTimes(2);
    expect(mockSend).toHaveBeenCalledWith(
      expect.objectContaining({
        notification: expect.objectContaining({
          title: 'Your crew is growing',
        }),
      })
    );
  });
});
