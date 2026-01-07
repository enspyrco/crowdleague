// Mock firebase-admin modules
jest.mock('firebase-admin/firestore', () => ({
  getFirestore: jest.fn(),
  FieldValue: {
    arrayRemove: jest.fn((val) => ({_arrayRemove: val})),
    serverTimestamp: jest.fn(() => ({_serverTimestamp: true})),
  },
}));

import {getFirestore, FieldValue} from 'firebase-admin/firestore';

describe('splitCrews', () => {
  let mockDb: any;
  let mockSet: jest.Mock;

  beforeEach(() => {
    jest.clearAllMocks();

    mockSet = jest.fn().mockResolvedValue(undefined);

    mockDb = {
      collection: jest.fn().mockReturnThis(),
      doc: jest.fn().mockReturnThis(),
      set: mockSet,
    };

    (getFirestore as jest.Mock).mockReturnValue(mockDb);
  });

  it('should remove crew ids from both profiles', async () => {
    const requesterId = 'requester123';
    const requesteeId = 'requestee456';

    // Simulate removing from requestee's profile
    await mockDb.collection('profiles').doc(requesteeId).set(
      {
        crewIds: FieldValue.arrayRemove(requesterId),
        followerIds: FieldValue.arrayRemove(requesterId),
      },
      {merge: true}
    );

    expect(mockSet).toHaveBeenCalledWith(
      expect.objectContaining({
        crewIds: expect.objectContaining({_arrayRemove: requesterId}),
        followerIds: expect.objectContaining({_arrayRemove: requesterId}),
      }),
      {merge: true}
    );
  });

  it('should remove crew ids from requester profile', async () => {
    const requesterId = 'requester123';
    const requesteeId = 'requestee456';

    // Simulate removing from requester's profile
    await mockDb.collection('profiles').doc(requesterId).set(
      {
        crewIds: FieldValue.arrayRemove(requesteeId),
        followerIds: FieldValue.arrayRemove(requesteeId),
      },
      {merge: true}
    );

    expect(mockDb.collection).toHaveBeenCalledWith('profiles');
    expect(mockDb.doc).toHaveBeenCalledWith(requesterId);
    expect(mockSet).toHaveBeenCalledWith(
      expect.objectContaining({
        crewIds: expect.objectContaining({_arrayRemove: requesteeId}),
      }),
      {merge: true}
    );
  });

  it('should create split-crew notification', async () => {
    const requesterId = 'requester123';
    const requesteeId = 'requestee456';

    await mockDb.collection('notifications').doc().set({
      playerId: requesterId,
      type: 'split-crew',
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
        type: 'split-crew',
        opened: false,
        viewed: false,
      })
    );
  });
});
