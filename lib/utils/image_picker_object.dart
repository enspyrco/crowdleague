import 'dart:io';

import 'package:meta/meta.dart';
import 'package:image_picker/image_picker.dart';

/// Just wraps the ImagePicker singleton in an an object that
/// calls the static functions of the same name
class ImagePickerObject {
  /// Returns a [File] object pointing to the image that was picked.
  ///
  /// The returned [File] is intended to be used within a single APP session. Do not save the file path and use it across sessions.
  ///
  /// The `source` argument controls where the image comes from. This can
  /// be either [ImageSource.camera] or [ImageSource.gallery].
  ///
  /// If specified, the image will be at most `maxWidth` wide and
  /// `maxHeight` tall. Otherwise the image will be returned at it's
  /// original width and height.
  /// The `imageQuality` argument modifies the quality of the image, ranging from 0-100
  /// where 100 is the original/max quality. If `imageQuality` is null, the image with
  /// the original quality will be returned. Compression is only supportted for certain
  /// image types such as JPEG. If compression is not supported for the image that is picked,
  /// an warning message will be logged.
  ///
  /// Use `preferredCameraDevice` to specify the camera to use when the `source` is [ImageSource.camera].
  /// The `preferredCameraDevice` is ignored when `source` is [ImageSource.gallery]. It is also ignored if the chosen camera is not supported on the device.
  /// Defaults to [CameraDevice.rear].
  ///
  /// In Android, the MainActivity can be destroyed for various reasons. If that happens, the result will be lost
  /// in this call. You can then call [retrieveLostData] when your app relaunches to retrieve the lost data.
  Future<File> pickImage(
      {@required ImageSource source,
      double maxWidth,
      double maxHeight,
      int imageQuality,
      CameraDevice preferredCameraDevice = CameraDevice.rear}) {
    return ImagePicker.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        preferredCameraDevice: preferredCameraDevice);
  }
}
