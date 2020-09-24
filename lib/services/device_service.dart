import 'dart:io';

import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:image_picker/image_picker.dart';

class DeviceService {
  final ImagePicker _picker;

  DeviceService({ImagePicker imagePicker}) : _picker = imagePicker;

  Future<String> pickProfilePic() async {
    final file = await _picker.getImage(source: ImageSource.gallery);
    return file?.path;
  }

  PlatformType get platformType {
    return (Platform.isIOS)
        ? PlatformType.ios
        : (Platform.isMacOS)
            ? PlatformType.macOS
            : PlatformType.android;
  }
}
