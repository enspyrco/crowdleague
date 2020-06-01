import config from "./config";

export const start = () => {
  console.log("Started execution with configuration", config);
};

export const constructedFilePath = (path: string) => {
  console.log(`Constructed file path: '${path}'`);
};

export const deletionFailed = (filePath: string, error: any) => {
  console.error(`Deleting ${filePath} returned: ${error}`);
}

export const deletedFile = (identifier: string) => {
  console.log(`Successfully deleted ${identifier}`);
}

export const complete = () => {
  console.log("Completed removing profile pic files");
};

export const failed = (numFailures: number, userId: string, picId: string) => {
  console.error(`There were ${numFailures} failures deleting profile pic files, added to "leaguers/${userId}/failed_profile_pics/${picId}"`);
};
