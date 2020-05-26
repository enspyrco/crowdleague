export default {
  cacheControlHeader: process.env.CACHE_CONTROL_HEADER,
  imageSizes: "100x100,200x200,500x500".split(","),
  resizedImagesPath: process.env.RESIZED_IMAGES_PATH,
  deleteOriginalFile: process.env.DELETE_ORIGINAL_FILE === "true",
};
