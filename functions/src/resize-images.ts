import * as functions from 'firebase-functions/v2';
import {StorageEvent} from 'firebase-functions/lib/v2/providers/storage';
import {Storage, Bucket, File} from '@google-cloud/storage';
import * as logger from 'firebase-functions/logger';
import sharp from 'sharp';
import * as path from 'path';
import {getFirestore, FieldValue} from 'firebase-admin/firestore';

interface ImageSize {
  width: number;
  height: number;
  suffix: string;
}

interface ResizedImage {
  size: string;
  path: string;
}

// Define the target image sizes
const SIZES: ImageSize[] = [
  {width: 800, height: 800, suffix: 'large'},
  {width: 400, height: 400, suffix: 'medium'},
  {width: 200, height: 200, suffix: 'small'},
];

/**
 * Process resizing of an image
 * @constructor
 * @param {Bucket} bucket - The bucket the original file is in
 * @param {File} originalFile
 * @param {string} filePath
 * @param {string} contentType
 */
async function processImage(
  bucket: Bucket,
  originalFile: File,
  filePath: string,
  contentType: string
): Promise<ResizedImage[]> {
  const [imageBuffer] = await originalFile.download();
  const fileName = path.basename(filePath);

  const resizePromises = SIZES.map(async (size: ImageSize) => {
    const {width, height, suffix} = size;

    // Generate new filename
    const newFileName = `${path.parse(fileName).name}` +
      `_${suffix}${path.parse(fileName).ext}`;
    const newFilePath = path.join(path.dirname(filePath), newFileName);

    // Resize image
    const resizedBuffer = await sharp(imageBuffer)
      .resize(width, height, {
        fit: 'inside',
        withoutEnlargement: true,
      })
      .toBuffer();

    // Upload or update resized image
    const newFile = bucket.file(newFilePath);
    await newFile.save(resizedBuffer, {
      metadata: {
        contentType,
        metadata: {
          resizedBy: 'storage-trigger',
          originalName: fileName,
          lastUpdated: new Date().toISOString(),
        },
      },
    });

    return {
      size: suffix,
      path: newFilePath,
    };
  });

  return Promise.all(resizePromises);
}

/**
 * Save resized images
 * @constructor
 * @param {StorageEvent} event - The event that triggered the function
 * @param {string} databaseName - The database the function accesses
 */
async function saveImages(event: StorageEvent, databaseName: string) {
  const bucketName = event.data.bucket;
  const filePath = event.data.name;
  const fileName = path.basename(filePath);
  const contentType = event.data.contentType;
  const folders = path.dirname(filePath).split(path.sep);
  const area = folders[0]; // venues or profiles
  const areaId = folders[1]; // venueId or profileId
  const timestamp = fileName.split('.')[0];

  // Exit if this is triggered by a resized image
  if (SIZES.some((size) => fileName.includes(`_${size.suffix}`))) {
    logger.log('Skipping already resized image:', fileName);
    return null;
  }

  // Exit if this is not an image
  if (!contentType?.startsWith('image/')) {
    logger.log('This is not an image:', fileName);
    return null;
  }

  try {
    const firestore = getFirestore(databaseName);

    // Check if this is an update or new file
    const isUpdate = event.data.metageneration > 1;
    logger.log(`Processing ${isUpdate ? 'update to' : 'new'} image:`,
      fileName);

    const storage = new Storage();
    const bucket = storage.bucket(bucketName);
    const file = bucket.file(filePath);

    // Update the status of the profile pic processing
    await firestore.collection(area).doc(areaId).set({
      picStatus: 'processing'}, {merge: true}
    );

    // Process the image
    const results = await processImage(bucket, file, filePath, contentType);

    logger.log(`Saved image with name (timestamp): ${timestamp} ` +
      `to ${area}/${areaId}/`);

    // Set the picId and add update the status of the profile pic processing.
    await firestore.collection(area).doc(areaId).set({
      picId: +timestamp, picStatus: 'complete'}, {merge: true}
    );
    // Add the picId to the picIds array, which keeps track of uploaded
    // profile pics.
    await firestore.collection(area).doc(areaId).update({
      picIds: FieldValue.arrayUnion(+timestamp),
    });

    return results;
  } catch (error) {
    logger.error('Error processing image:',
      error instanceof Error ? error.message : 'Unknown error');
    throw error;
  }
}

// The upload file is assumed to have form `bucketName/userId/timestamp.jpg`
export const resizeImagesAus = functions.storage.onObjectFinalized(
  {
    bucket: 'crowdleague-project-aus',
    region: 'australia-southeast1',
  },
  async (event: StorageEvent) => {
    saveImages(event, '(default)');
  });

// The upload file is assumed to have form `bucketName/userId/timestamp.jpg`
export const resizeImagesUsa = functions.storage.onObjectFinalized(
  {
    bucket: 'crowdleague-project.firebasestorage.app',
    region: 'us-central1',
  },
  async (event: StorageEvent) => {
    saveImages(event, 'firestore-usa');
  });

