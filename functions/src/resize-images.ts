import * as functions from 'firebase-functions/v2';
import * as admin from 'firebase-admin';
import {getStorage} from 'firebase-admin/storage';
import * as sharp from 'sharp';

// Initialize Firebase Admin SDK
admin.initializeApp();

// Define the target image sizes
const sizes = [
  {width: 200, height: 200, suffix: '_thumb'},
  {width: 500, height: 500, suffix: '_medium'},
  {width: 800, height: 800, suffix: '_large'},
];

// Cloud Function triggered by new file uploads to the bucket
export const resizeImages = functions.storage.onObjectFinalized(
  async (event) => {
    const file = event.data;
    const filePath = file.name;
    const bucket = getStorage().bucket(file.bucket);
    const fileName = filePath.split('/').pop();
    const fileDir = filePath.split(fileName)[0];

    // Check if the file is an image
    if (!file.contentType?.startsWith('image/')) {
      console.log('File is not an image, skipping resize.');
      return;
    }

    // Download the file from the bucket
    const [imageFile] = await bucket.file(filePath).download();

    // Resize the image for each size
    for (const size of sizes) {
      const resizedImage = await sharp(imageFile)
        .resize(size.width, size.height, {
          fit: 'inside',
          withoutEnlargement: true,
        })
        .toBuffer();

      // Define the path for the resized image (overwrite if it exists)
      const resizedFilePath =
        `${fileDir}${fileName?.replace(/\.[^/.]+$/, '')}${size.suffix}.jpg`;

      // Upload the resized image back to the bucket
      // (overwrites if the file exists)
      await bucket.file(resizedFilePath).save(resizedImage, {
        metadata: {
          contentType: 'image/jpeg',
        },
      });

      console.log(`Resized image uploaded to: ${resizedFilePath}`);
    }

    console.log('All resized images uploaded successfully.');
  });

/////////// claude
// import * as functions from 'firebase-functions';
// import * as admin from 'firebase-admin';
// import * as sharp from 'sharp';
// import * as path from 'path';

// admin.initializeApp();

// interface ImageSize {
//   width: number;
//   height: number;
//   suffix: string;
// }

// interface ResizedImage {
//   size: string;
//   path: string;
//   url: string;
// }

// interface FirestoreImage {
//   original: string;
//   resized: {
//     [key: string]: {
//       path: string;
//       url: string;
//     };
//   };
//   lastUpdated: admin.firestore.Timestamp;
//   createdAt: admin.firestore.Timestamp;
// }

// const SIZES: ImageSize[] = [
//   { width: 800, height: 800, suffix: 'large' },
//   { width: 400, height: 400, suffix: 'medium' },
//   { width: 200, height: 200, suffix: 'thumbnail' }
// ];

// async function processImage(
//   bucket: admin.storage.Bucket,
//   originalFile: admin.storage.File,
//   filePath: string,
//   contentType: string
// ): Promise<ResizedImage[]> {
//   const [imageBuffer] = await originalFile.download();
//   const fileName = path.basename(filePath);

//   const resizePromises = SIZES.map(async (size: ImageSize) => {
//     const { width, height, suffix } = size;
    
//     // Generate new filename
//     const newFileName = `${path.parse(fileName).name}_${suffix}${path.parse(fileName).ext}`;
//     const newFilePath = path.join(path.dirname(filePath), newFileName);
    
//     // Resize image
//     const resizedBuffer = await sharp(imageBuffer)
//       .resize(width, height, {
//         fit: 'inside',
//         withoutEnlargement: true
//       })
//       .toBuffer();

//     // Upload or update resized image
//     const newFile = bucket.file(newFilePath);
//     await newFile.save(resizedBuffer, {
//       metadata: {
//         contentType,
//         metadata: {
//           resizedBy: 'storage-trigger',
//           originalName: fileName,
//           lastUpdated: new Date().toISOString()
//         }
//       }
//     });

//     // Get download URL
//     const [url] = await newFile.getSignedUrl({
//       action: 'read',
//       expires: '03-01-2500'
//     });

//     return {
//       size: suffix,
//       path: newFilePath,
//       url
//     };
//   });

//   return Promise.all(resizePromises);
// }

// export const resizeImage = functions.storage
//   .object()
//   .onFinalize(async (object: functions.storage.ObjectMetadata): Promise<ResizedImage[] | null> => {
//     if (!object.name || !object.bucket || !object.contentType) {
//       console.error('Invalid object metadata');
//       return null;
//     }

//     const filePath = object.name;
//     const fileName = path.basename(filePath);
//     const bucket = admin.storage().bucket(object.bucket);
//     const file = bucket.file(filePath);

//     // Exit if this is triggered by a resized image
//     if (SIZES.some(size => fileName.includes(`_${size.suffix}`))) {
//       console.log('Skipping already resized image:', fileName);
//       return null;
//     }

//     // Exit if this is not an image
//     if (!object.contentType.startsWith('image/')) {
//       console.log('This is not an image:', fileName);
//       return null;
//     }

//     try {
//       // Check if this is an update or new file
//       const isUpdate = object.metageneration > 1;
//       console.log(`Processing ${isUpdate ? 'update to' : 'new'} image:`, fileName);

//       // Process the image
//       const results = await processImage(bucket, file, filePath, object.contentType);
      
//       // Get reference to existing document
//       const docRef = admin.firestore().collection('images').doc(fileName);
//       const docSnapshot = await docRef.get();
      
//       // Prepare Firestore data
//       const firestoreData: Partial<FirestoreImage> = {
//         original: filePath,
//         resized: results.reduce((acc, item) => ({
//           ...acc,
//           [item.size]: {
//             path: item.path,
//             url: item.url
//           }
//         }), {}),
//         lastUpdated: admin.firestore.FieldValue.serverTimestamp() as unknown as admin.firestore.Timestamp
//       };

//       // Only set createdAt if this is a new document
//       if (!docSnapshot.exists) {
//         firestoreData.createdAt = admin.firestore.FieldValue.serverTimestamp() as unknown as admin.firestore.Timestamp;
//       }

//       // Update Firestore
//       await docRef.set(firestoreData, { merge: true });

//       console.log(`Successfully ${isUpdate ? 'updated' : 'processed'} image:`, fileName);
//       return results;

//     } catch (error) {
//       console.error('Error processing image:', error instanceof Error ? error.message : 'Unknown error');
//       throw error;
//     }
// });