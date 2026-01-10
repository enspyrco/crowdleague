import * as functions from 'firebase-functions/v2';
import {StorageEvent} from 'firebase-functions/lib/v2/providers/storage';
import {Storage, Bucket, File} from '@google-cloud/storage';
import * as logger from 'firebase-functions/logger';
import sharp from 'sharp';
import * as path from 'path';
import {getFirestore} from 'firebase-admin/firestore';

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
 */
async function saveImages(event: StorageEvent) {
  const bucketName = event.data.bucket;
  const filePath = event.data.name;
  const fileName = path.basename(filePath);
  const contentType = event.data.contentType;

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

  // Exit if this is an icon file
  if (fileName.includes('_icon')) {
    logger.log('Skipping icon file:', fileName);
    return null;
  }

  try {
    // Check if this is an update or new file
    const isUpdate = event.data.metageneration > 1;
    logger.log(`Processing ${isUpdate ? 'update to' : 'new'} image:`,
      fileName);

    const storage = new Storage();
    const bucket = storage.bucket(bucketName);
    const file = bucket.file(filePath);

    // Process the image
    const results = await processImage(bucket, file, filePath, contentType);

    return results;
  } catch (error) {
    logger.error('Error processing image:',
      error instanceof Error ? error.message : 'Unknown error');
    throw error;
  }
}

/**
 * Handle venue photo uploads: {venueId}_{photoIndex}.jpg
 * Updates photoCount in Firestore when processing
 * @param {StorageEvent} event - The event that triggered the function
 * @param {string} databaseName - The database the function accesses
 */
async function handleVenuePhoto(event: StorageEvent, databaseName: string) {
  const filePath = event.data.name;
  const fileName = path.basename(filePath);

  // First do the common image processing
  const results = await saveImages(event);
  if (!results) return null;

  // Handle venue photos: {venueId}_{photoIndex}.jpg
  // (no prefix needed in dedicated bucket)
  const venuePhotoMatch = fileName.match(/^([^_]+)_(\d+)\.jpg$/);
  if (venuePhotoMatch) {
    const venueId = venuePhotoMatch[1];
    const photoIndex = parseInt(venuePhotoMatch[2], 10);
    logger.log(`Processing venue photo: venueId=${venueId}, ` +
      `photoIndex=${photoIndex}`);

    const firestore = getFirestore(databaseName);
    // Update photoCount in Firestore if this is a new highest index
    const venueRef = firestore.collection('venues').doc(venueId);
    const venueDoc = await venueRef.get();
    if (venueDoc.exists) {
      const currentCount = venueDoc.data()?.photoCount || 0;
      const newCount = photoIndex + 1;
      if (newCount > currentCount) {
        await venueRef.update({photoCount: newCount});
        logger.log(`Updated venue photoCount to ${newCount}`);
      }
    }
  }

  return results;
}

/**
 * Handle profile photo uploads: {userId}/{timestamp}.jpg
 * Updates picId in Firestore when processing
 * @param {StorageEvent} event - The event that triggered the function
 * @param {string} databaseName - The database the function accesses
 */
async function handleProfilePhoto(event: StorageEvent, databaseName: string) {
  const filePath = event.data.name;
  const fileName = path.basename(filePath);

  // First do the common image processing
  const results = await saveImages(event);
  if (!results) return null;

  // Handle profile photos: {userId}/{timestamp}.jpg
  // (no prefix needed in dedicated bucket)
  const folders = path.dirname(filePath).split(path.sep);
  const userId = folders[0];
  const timestamp = fileName.split('.')[0];

  if (userId && timestamp) {
    logger.log(`Processing profile photo: userId=${userId}, ` +
      `timestamp=${timestamp}`);

    const firestore = getFirestore(databaseName);
    // Set the picId for profile photos
    await firestore.collection('profiles').doc(userId).set({
      picId: +timestamp}, {merge: true}
    );
    logger.log(`Updated profile picId to ${timestamp}`);
  }

  return results;
}

// Trigger for venue photos in crowdleague-venues bucket
export const resizeVenueImages = functions.storage.onObjectFinalized(
  {
    bucket: 'crowdleague-venues',
    region: 'us-central1',
  },
  async (event: StorageEvent) => {
    await handleVenuePhoto(event, '(default)');
  });

// Trigger for profile photos in crowdleague-profiles bucket
export const resizeProfileImages = functions.storage.onObjectFinalized(
  {
    bucket: 'crowdleague-profiles',
    region: 'us-central1',
  },
  async (event: StorageEvent) => {
    await handleProfilePhoto(event, '(default)');
  });

