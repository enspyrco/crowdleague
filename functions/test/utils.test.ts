import {getDocumentSnapshot} from '../src/utils';
import {HttpsError} from 'firebase-functions/https';

describe('utils', () => {
  describe('getDocumentSnapshot', () => {
    it('returns document data when snapshot exists', async () => {
      const mockData = {name: 'Test', value: 123};
      const mockRef = {
        id: 'testDoc',
        get: jest.fn().mockResolvedValue({
          exists: true,
          data: () => mockData,
        }),
      } as unknown as FirebaseFirestore.DocumentReference;

      const result = await getDocumentSnapshot(mockRef);

      expect(result).toEqual(mockData);
      expect(mockRef.get).toHaveBeenCalledTimes(1);
    });

    it('throws HttpsError when snapshot does not exist', async () => {
      const mockRef = {
        id: 'nonexistent',
        get: jest.fn().mockResolvedValue({
          exists: false,
          data: () => undefined,
        }),
      } as unknown as FirebaseFirestore.DocumentReference;

      await expect(getDocumentSnapshot(mockRef)).rejects.toThrow(HttpsError);
      await expect(getDocumentSnapshot(mockRef)).rejects.toThrow(
        'nonexistent snapshot did not exist'
      );
    });

    it('throws HttpsError when snapshot.data() is undefined', async () => {
      const mockRef = {
        id: 'emptyDoc',
        get: jest.fn().mockResolvedValue({
          exists: true,
          data: () => undefined,
        }),
      } as unknown as FirebaseFirestore.DocumentReference;

      await expect(getDocumentSnapshot(mockRef)).rejects.toThrow(HttpsError);
      await expect(getDocumentSnapshot(mockRef)).rejects.toThrow(
        'emptyDoc snapshot.data() was undefined'
      );
    });
  });
});
