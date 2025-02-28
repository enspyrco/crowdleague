import * as admin from 'firebase-admin';
import {getStorage} from 'firebase-admin/storage';
import * as fs from 'fs/promises';
import * as path from 'path';
import sharp from 'sharp'; // Image processing library

// Test configuration
const TEST_BUCKET = 'crowdleague-project.firebasestorage.app';
const PROJECT_ID = 'crowdleague-project';
const UPLOAD_PATH = 'test-uploads/test-image.png';
const RESIZED_PATH = 'test-uploads/test-image_small.png';

describe('Storage Upload Integration Test', () => {
  let storage: admin.storage.Storage;

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
   * Clears test data from Storage.
   *
   * This function performs the following actions:
   * 1. Deletes a specific file from the test storage bucket.
   *
   * @async
   * @function clearTestData
   * @return {Promise<void>} A promise that resolves when the test data
   * has been cleared.
   */
  async function clearTestData(): Promise<void> {
    // Clear Storage
    try {
      await storage.bucket(TEST_BUCKET).file(UPLOAD_PATH).delete();
    } catch (error) {
      // Ignore if file doesn't exist
    }
  }

  test('should process uploaded image and save different sizes',
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

      // Wait for the function to trigger and process the document
      await new Promise((resolve) => setTimeout(resolve, 5000));

      // Verify the resized image exists in Storage
      const [resizedFileExists] = await storage.bucket(TEST_BUCKET)
        .file(`${RESIZED_PATH}`).exists();
      expect(resizedFileExists).toBe(true);

      // (Optional) Verify the resized image dimensions using sharp
      const [resizedImageBuffer] = await storage.bucket(TEST_BUCKET)
        .file(`${RESIZED_PATH}`).download();
      const resizedImageMetadata = await sharp(resizedImageBuffer).metadata();
      expect(resizedImageMetadata.width).toBe(200);
      expect(resizedImageMetadata.height).toBe(200);
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

    // Verify no resized file exists in Storage
    const [resizedFileExists] = await storage.bucket(TEST_BUCKET)
      .file('test-uploads/test_small.txt').exists();
    expect(resizedFileExists).toBe(false);
  });
});
