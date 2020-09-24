import 'package:crowdleague/enums/device/platform_type.dart';
import 'package:crowdleague/utils/wrappers/platform_wrapper.dart';
import 'package:image_picker/image_picker.dart';

class DeviceService {
  final ImagePicker _picker;
  final PlatformWrapper _platform;
  DeviceService(
      {ImagePicker imagePicker,
      PlatformWrapper platform = const PlatformWrapper()})
      : _picker = imagePicker,
        _platform = platform;

  Future<String> pickProfilePic() async {
    final file = await _picker.getImage(source: ImageSource.gallery);
    return file?.path;
  }

  PlatformType get platformType {
    return (_platform.isIOS)
        ? PlatformType.ios
        : (_platform.isMacOS)
            ? PlatformType.macOS
            : PlatformType.android;
  }
}
