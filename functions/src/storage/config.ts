export default {
  cacheControlHeader: process.env.CACHE_CONTROL_HEADER,
  imageSizes: "50x50,100x100,500x500".split(","),
  resizedImagesPath: process.env.RESIZED_IMAGES_PATH,
  deleteOriginalFile: process.env.DELETE_ORIGINAL_FILE === "true",
};
