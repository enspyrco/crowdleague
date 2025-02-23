import * as functions from 'firebase-functions/v2';
import {StorageEvent} from 'firebase-functions/lib/v2/providers/storage';
import {Storage, Bucket, File} from '@google-cloud/storage';
import * as logger from 'firebase-functions/logger';
import sharp from 'sharp';
import * as path from 'path';

interface ImageSize {
  width: number;
  height: number;
  suffix: string;
}

interface ResizedImage {
  size: string;
  path: string;
  url: string;
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

    // Get download URL
    const [url] = await newFile.getSignedUrl({
      action: 'read',
      expires: '03-01-2500',
    });

    return {
      size: suffix,
      path: newFilePath,
      url,
    };
  });

  return Promise.all(resizePromises);
}

export const resizeImages = functions.storage.onObjectFinalized(
  // {
  //   bucket: 'myBucket',
  //   region: 'asia-northeast1',
  // },
  async (event: StorageEvent) => {
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
  });
