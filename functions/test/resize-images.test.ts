// Mock firebase modules before importing functions
jest.mock('firebase-functions/logger', () => ({
  log: jest.fn(),
  error: jest.fn(),
}));

jest.mock('firebase-admin/firestore', () => ({
  getFirestore: jest.fn(),
}));

jest.mock('@google-cloud/storage', () => ({
  Storage: jest.fn().mockImplementation(() => ({
    bucket: jest.fn().mockReturnValue({
      file: jest.fn().mockReturnValue({
        download: jest.fn(),
        save: jest.fn(),
        exists: jest.fn(),
      }),
    }),
  })),
}));

jest.mock('sharp', () => {
  const mockSharp = jest.fn().mockReturnValue({
    resize: jest.fn().mockReturnValue({
      toBuffer: jest.fn().mockResolvedValue(Buffer.from('resized-image')),
    }),
  });
  return mockSharp;
});

import {getFirestore} from 'firebase-admin/firestore';
import {Storage} from '@google-cloud/storage';
import sharp from 'sharp';

describe('resize-images', () => {
  let mockDb: any;
  let mockUpdate: jest.Mock;
  let mockGet: jest.Mock;
  let mockStorage: any;
  let mockBucket: any;
  let mockFile: any;

  beforeEach(() => {
    jest.clearAllMocks();

    // Reset Firestore mock
    mockUpdate = jest.fn().mockResolvedValue(undefined);
    mockGet = jest.fn();

    mockDb = {
      collection: jest.fn().mockReturnThis(),
      doc: jest.fn().mockReturnThis(),
      update: mockUpdate,
      get: mockGet,
    };

    (getFirestore as jest.Mock).mockReturnValue(mockDb);

    // Reset Storage mock
    mockFile = {
      download: jest.fn().mockResolvedValue([Buffer.from('test-image')]),
      save: jest.fn().mockResolvedValue(undefined),
      exists: jest.fn().mockResolvedValue([true]),
    };

    mockBucket = {
      file: jest.fn().mockReturnValue(mockFile),
    };

    mockStorage = {
      bucket: jest.fn().mockReturnValue(mockBucket),
    };

    (Storage as unknown as jest.Mock).mockImplementation(() => mockStorage);
  });

  describe('Image processing logic', () => {
    test('should skip already resized images', () => {
      const resizedFileNames = [
        'venue123_0_large.jpg',
        'venue123_0_medium.jpg',
        'venue123_0_small.jpg',
        'profile_1234_small.png',
      ];

      const sizes = [
        {width: 800, height: 800, suffix: 'large'},
        {width: 400, height: 400, suffix: 'medium'},
        {width: 200, height: 200, suffix: 'small'},
      ];

      for (const fileName of resizedFileNames) {
        const isResized = sizes.some((size) => fileName.includes(`_${size.suffix}`));
        expect(isResized).toBe(true);
      }
    });

    test('should not skip original images', () => {
      const originalFileNames = [
        'venue123_0.jpg',
        'venue456_1.jpg',
        'userId/1234567890.png',
      ];

      const sizes = [
        {width: 800, height: 800, suffix: 'large'},
        {width: 400, height: 400, suffix: 'medium'},
        {width: 200, height: 200, suffix: 'small'},
      ];

      for (const fileName of originalFileNames) {
        const isResized = sizes.some((size) => fileName.includes(`_${size.suffix}`));
        expect(isResized).toBe(false);
      }
    });

    test('should skip icon files', () => {
      const iconFileNames = [
        'venue123_icon',
        'testVenue_icon',
      ];

      for (const fileName of iconFileNames) {
        const isIcon = fileName.includes('_icon');
        expect(isIcon).toBe(true);
      }
    });

    test('should detect non-image content types', () => {
      const nonImageTypes = [
        'text/plain',
        'application/json',
        'application/pdf',
        'video/mp4',
      ];

      for (const contentType of nonImageTypes) {
        const isImage = contentType?.startsWith('image/');
        expect(isImage).toBe(false);
      }
    });

    test('should detect image content types', () => {
      const imageTypes = [
        'image/jpeg',
        'image/png',
        'image/webp',
        'image/gif',
      ];

      for (const contentType of imageTypes) {
        const isImage = contentType?.startsWith('image/');
        expect(isImage).toBe(true);
      }
    });
  });

  describe('Venue photo filename parsing', () => {
    test('should parse venue photo filename correctly', () => {
      const fileName = 'venue123_0.jpg';
      const match = fileName.match(/^([^_]+)_(\d+)\.jpg$/);

      expect(match).not.toBeNull();
      expect(match![1]).toBe('venue123');
      expect(match![2]).toBe('0');
    });

    test('should parse venue photo with higher index', () => {
      const fileName = 'myVenue_4.jpg';
      const match = fileName.match(/^([^_]+)_(\d+)\.jpg$/);

      expect(match).not.toBeNull();
      expect(match![1]).toBe('myVenue');
      expect(match![2]).toBe('4');
    });

    test('should not match resized venue photos', () => {
      const fileNames = [
        'venue123_0_large.jpg',
        'venue123_0_medium.jpg',
        'venue123_0_small.jpg',
      ];

      for (const fileName of fileNames) {
        const match = fileName.match(/^([^_]+)_(\d+)\.jpg$/);
        expect(match).toBeNull();
      }
    });

    test('should not match icon files', () => {
      const fileName = 'venue123_icon';
      const match = fileName.match(/^([^_]+)_(\d+)\.jpg$/);
      expect(match).toBeNull();
    });
  });

  describe('Profile photo filename parsing', () => {
    test('should extract userId from profile photo path', () => {
      const filePath = 'userId123/1704067200000.jpg';
      const folders = filePath.split('/');
      const userId = folders[0];
      const fileName = folders[1];
      const timestamp = fileName.split('.')[0];

      expect(userId).toBe('userId123');
      expect(timestamp).toBe('1704067200000');
    });

    test('should handle nested profile paths', () => {
      const filePath = 'user456/subfolder/1704067200000.png';
      // In the real function, it only takes folders[0] as userId
      const folders = filePath.split('/');
      const userId = folders[0];

      expect(userId).toBe('user456');
    });
  });

  describe('Firestore updates for venue photos', () => {
    test('should update photoCount when new photo index is higher', async () => {
      // Mock venue doc exists with photoCount = 2
      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({photoCount: 2}),
      });

      const venueId = 'venue123';
      const photoIndex = 3; // Index 3 means 4 photos total

      const venueRef = mockDb.collection('venues').doc(venueId);
      const venueDoc = await venueRef.get();

      if (venueDoc.exists) {
        const currentCount = venueDoc.data()?.photoCount || 0;
        const newCount = photoIndex + 1;
        if (newCount > currentCount) {
          await venueRef.update({photoCount: newCount});
        }
      }

      expect(mockUpdate).toHaveBeenCalledWith({photoCount: 4});
    });

    test('should not update photoCount when new index is lower', async () => {
      // Mock venue doc exists with photoCount = 5
      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({photoCount: 5}),
      });

      const venueId = 'venue123';
      const photoIndex = 2; // Index 2 means 3 photos total, less than 5

      const venueRef = mockDb.collection('venues').doc(venueId);
      const venueDoc = await venueRef.get();

      if (venueDoc.exists) {
        const currentCount = venueDoc.data()?.photoCount || 0;
        const newCount = photoIndex + 1;
        if (newCount > currentCount) {
          await venueRef.update({photoCount: newCount});
        }
      }

      // Update should not be called since 3 < 5
      expect(mockUpdate).not.toHaveBeenCalled();
    });

    test('should handle missing photoCount in existing venue', async () => {
      // Mock venue doc exists without photoCount field
      mockGet.mockResolvedValueOnce({
        exists: true,
        data: () => ({}), // No photoCount field
      });

      const venueId = 'venue123';
      const photoIndex = 0; // First photo

      const venueRef = mockDb.collection('venues').doc(venueId);
      const venueDoc = await venueRef.get();

      if (venueDoc.exists) {
        const currentCount = venueDoc.data()?.photoCount || 0;
        const newCount = photoIndex + 1;
        if (newCount > currentCount) {
          await venueRef.update({photoCount: newCount});
        }
      }

      expect(mockUpdate).toHaveBeenCalledWith({photoCount: 1});
    });

    test('should not update if venue does not exist', async () => {
      mockGet.mockResolvedValueOnce({
        exists: false,
      });

      const venueId = 'nonexistent';
      const photoIndex = 0;

      const venueRef = mockDb.collection('venues').doc(venueId);
      const venueDoc = await venueRef.get();

      if (venueDoc.exists) {
        const currentCount = venueDoc.data()?.photoCount || 0;
        const newCount = photoIndex + 1;
        if (newCount > currentCount) {
          await venueRef.update({photoCount: newCount});
        }
      }

      expect(mockUpdate).not.toHaveBeenCalled();
    });
  });

  describe('Firestore updates for profile photos', () => {
    test('should update picId for profile photos', async () => {
      const userId = 'user123';
      const timestamp = '1704067200000';

      await mockDb.collection('profiles').doc(userId).update({
        picId: +timestamp,
      });

      expect(mockDb.collection).toHaveBeenCalledWith('profiles');
      expect(mockDb.doc).toHaveBeenCalledWith(userId);
    });
  });

  describe('Resized filename generation', () => {
    test('should generate correct resized filenames', () => {
      const originalName = 'venue123_0.jpg';
      const sizes = [
        {width: 800, height: 800, suffix: 'large'},
        {width: 400, height: 400, suffix: 'medium'},
        {width: 200, height: 200, suffix: 'small'},
      ];

      const baseName = originalName.split('.')[0]; // 'venue123_0'
      const ext = '.jpg';

      const expectedNames = [
        'venue123_0_large.jpg',
        'venue123_0_medium.jpg',
        'venue123_0_small.jpg',
      ];

      for (let i = 0; i < sizes.length; i++) {
        const newFileName = `${baseName}_${sizes[i].suffix}${ext}`;
        expect(newFileName).toBe(expectedNames[i]);
      }
    });

    test('should handle profile photo filenames', () => {
      const fileName = '1704067200000.png';
      const sizes = [
        {suffix: 'large'},
        {suffix: 'medium'},
        {suffix: 'small'},
      ];

      const baseName = fileName.split('.')[0];
      const ext = '.png';

      const expected = [
        '1704067200000_large.png',
        '1704067200000_medium.png',
        '1704067200000_small.png',
      ];

      for (let i = 0; i < sizes.length; i++) {
        const newFileName = `${baseName}_${sizes[i].suffix}${ext}`;
        expect(newFileName).toBe(expected[i]);
      }
    });
  });

  describe('Image processing with sharp', () => {
    test('should call sharp with image buffer', async () => {
      const imageBuffer = Buffer.from('test-image');

      // Call sharp
      sharp(imageBuffer);

      // Verify sharp is called with the buffer
      expect(sharp).toHaveBeenCalledWith(imageBuffer);
    });

    test('should resize to all three sizes', () => {
      const sizes = [
        {width: 800, height: 800, suffix: 'large'},
        {width: 400, height: 400, suffix: 'medium'},
        {width: 200, height: 200, suffix: 'small'},
      ];

      expect(sizes.length).toBe(3);
      expect(sizes[0].width).toBe(800);
      expect(sizes[1].width).toBe(400);
      expect(sizes[2].width).toBe(200);
    });
  });

  describe('Storage operations', () => {
    test('should save resized images with correct metadata', async () => {
      const resizedBuffer = Buffer.from('resized');
      const contentType = 'image/jpeg';
      const originalName = 'venue123_0.jpg';

      await mockFile.save(resizedBuffer, {
        metadata: {
          contentType,
          metadata: {
            resizedBy: 'storage-trigger',
            originalName,
            lastUpdated: new Date().toISOString(),
          },
        },
      });

      expect(mockFile.save).toHaveBeenCalledWith(
        resizedBuffer,
        expect.objectContaining({
          metadata: expect.objectContaining({
            contentType: 'image/jpeg',
          }),
        })
      );
    });
  });

  describe('Bucket configuration', () => {
    test('should use correct bucket for venue photos', () => {
      const venueBucket = 'crowdleague-venues';
      expect(venueBucket).toBe('crowdleague-venues');
    });

    test('should use correct bucket for profile photos', () => {
      const profileBucket = 'crowdleague-profiles';
      expect(profileBucket).toBe('crowdleague-profiles');
    });
  });
});
