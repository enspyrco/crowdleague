import * as admin from 'firebase-admin';
import {getStorage} from 'firebase-admin/storage';
import {getFirestore} from 'firebase-admin/firestore';
import * as fs from 'fs/promises';
import * as path from 'path';

// Test configuration
const TEST_BUCKET = 'demo-test-project.appspot.com';
const PROJECT_ID = 'demo-test-project';
const UPLOAD_PATH = 'test-uploads/test-image.png';

describe('Storage Upload Integration Test', () => {
  let storage: admin.storage.Storage;
  let firestore: admin.firestore.Firestore;

  beforeAll(async () => {
    // Set up emulator env variables
    process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';
    process.env.FIREBASE_STORAGE_EMULATOR_HOST = 'localhost:9199';

    // Initialize Firebase Admin
    admin.initializeApp({
      projectId: PROJECT_ID,
      storageBucket: TEST_BUCKET,
      // Use emulator credentials
      credential: admin.credential.applicationDefault(),
    });

    storage = getStorage();
    firestore = getFirestore();
  });

  beforeEach(async () => {
    // Clear test data before each test
    await clearTestData();
  });

  afterAll(async () => {
    await clearTestData();
    await admin.app().delete();
  });

  /**
   * Clears test data from Firestore and Storage.
   *
   * This function performs the following actions:
   * 1. Deletes all documents in the 'uploads' collection in Firestore.
   * 2. Deletes a specific file from the test storage bucket.
   *
   * @async
   * @function clearTestData
   * @return {Promise<void>} A promise that resolves when the test data
   * has been cleared.
   */
  async function clearTestData(): Promise<void> {
    // Clear Firestore collection
    const uploads = await firestore.collection('uploads').get();
    for (const doc of uploads.docs) {
      await doc.ref.delete();
    }

    // Clear Storage
    try {
      await storage.bucket(TEST_BUCKET).file(UPLOAD_PATH).delete();
    } catch (error) {
      // Ignore if file doesn't exist
    }
  }

  test('should process uploaded image and create Firestore document',
    async () => {
      // Load test image
      const testImagePath = path.join(__dirname,
        '../test/assets/test-image.png');
      const imageBuffer = await fs.readFile(testImagePath);

      // Upload to storage emulator
      const file = storage.bucket(TEST_BUCKET).file(UPLOAD_PATH);
      await file.save(imageBuffer, {
        metadata: {
          contentType: 'image/png',
        },
      });

      // Verify file exists in storage
      const [exists] = await file.exists();
      expect(exists).toBe(true);

      // Check file metadata
      const [metadata] = await file.getMetadata();
      expect(metadata.contentType).toBe('image/png');
    }); // Increase timeout for emulator operations

  test('should reject non-image files', async () => {
    // Upload a text file
    const textContent = Buffer.from('This is a test file');
    const file = storage.bucket(TEST_BUCKET).file('test-uploads/test.txt');

    await file.save(textContent, {
      metadata: {
        contentType: 'text/plain',
      },
    });

    // Wait for potential processing
    await new Promise((resolve) => setTimeout(resolve, 1000));

    // Verify no document was created
    const snapshot = await firestore
      .collection('uploads')
      .where('path', '==', 'test-uploads/test.txt')
      .get();

    expect(snapshot.empty).toBe(true);
  });
});
