import config from "./config";
import { DeleteFileResponse } from 'firebase-admin/node_modules/@google-cloud/storage';

export const start = () => {
  console.log("Started execution with configuration", config);
};

export const constructedFilePath = (path: string) => {
  console.log(`Constructed file path: '${path}'`);
};

// export const removingSizes = (sizesMap: Map<string, string>) => {
//   console.log('Sizes are: ');
//   for(const key in sizesMap.keys()) {
//       console.log(`${key} : ${sizesMap.get(key)}, `);
//   }
// }

export const deleteFileResponse = (identifier: string, response : DeleteFileResponse) => {
    console.log(`deleted ${identifier} with response: ${response}`);
}

export const complete = () => {
  console.log("Completed removing profile pic files");
};

export const failed = (failures: any) => {
  console.error("Failed removing profile pic files: "+failures);
};

// export const objectNameUndefined = () => {
//   console.log("Object name was undefined");
// }

// export const addProfilePicsToFirestore = () => {
//   console.log('Adding profile pic data to Firestore...');
// }

// export const addedProfilePicsToFirestore = () => {
//   console.log('Added profile pic data to Firestore.');
// }

// export const errorAddingProfilePicsToFirestore = (err: Error)  => {
//   console.error("Error when adding profile pic data to Firestore", err);
// }

// export const noContentType = () => {
//   console.log(`File has no Content-Type, no processing is required`);
// };

// export const contentTypeInvalid = (contentType: string) => {
//   console.log(
//     `File of type '${contentType}' is not an image, no processing is required`
//   );
// };

// export const error = (err: Error) => {
//   console.error("Error when resizing image", err);
// };

// export const errorDeleting = (err: Error) => {
//   console.warn("Error when deleting temporary files", err);
// };

// export const imageAlreadyResized = () => {
//   console.log("File is already a resized image, no processing is required");
// };

// export const imageDownloaded = (remotePath: string, localPath: string) => {
//   console.log(`Downloaded image file: '${remotePath}' to '${localPath}'`);
// };

// export const imageDownloading = (path: string) => {
//   console.log(`Downloading image file: '${path}'`);
// };

// export const imageResized = (path: string) => {
//   console.log(`Resized image created at '${path}'`);
// };

// export const imageResizing = (path: string, size: string) => {
//   console.log(`Resizing image at path '${path}' to size: ${size}`);
// };

// export const imageUploaded = (path: string) => {
//   console.log(`Uploaded resized image to '${path}'`);
// };

// export const imageUploading = (path: string) => {
//   console.log(`Uploading resized image to '${path}'`);
// };

// export const init = () => {
//   console.log("Initializing extension with configuration", config);
// };

// export const tempDirectoryCreated = (directory: string) => {
//   console.log(`Created temporary directory: '${directory}'`);
// };

// export const tempDirectoryCreating = (directory: string) => {
//   console.log(`Creating temporary directory: '${directory}'`);
// };

// export const tempOriginalFileDeleted = (path: string) => {
//   console.log(`Deleted temporary original file: '${path}'`);
// };

// export const tempOriginalFileDeleting = (path: string) => {
//   console.log(`Deleting temporary original file: '${path}'`);
// };

// export const tempResizedFileDeleted = (path: string) => {
//   console.log(`Deleted temporary resized file: '${path}'`);
// };

// export const tempResizedFileDeleting = (path: string) => {
//   console.log(`Deleting temporary resized file: '${path}'`);
// };

// export const remoteFileDeleted = (path: string) => {
//   console.log(`Deleted original file from storage bucket: '${path}'`);
// };

// export const remoteFileDeleting = (path: string) => {
//   console.log(`Deleting original file from storage bucket: '${path}'`);
// };
