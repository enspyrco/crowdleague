import 'package:crowdleague/utils/image_picker_object.dart';
import 'package:image_picker/image_picker.dart';

class DeviceService {
  final ImagePickerObject imagePicker;

  DeviceService(this.imagePicker);

  Future<String> pickProfilePic() async {
    final file = await imagePicker.pickImage(source: ImageSource.gallery);
    return file?.path;
  }
}
