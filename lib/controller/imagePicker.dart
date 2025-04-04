import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  ImagePicker imagePicker = ImagePicker();
  XFile? image;

  Future<String?> getImage(ImageSource source) async {
    image = await imagePicker.pickImage(source:source);
    if (image != null) {
      return image!.path;
    } else {
      return null;
    }
  }
}
