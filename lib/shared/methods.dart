import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

Future<File?> selectImageCamera() async {
  final ImagePicker _picker = ImagePicker();
  try {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
      if (image != null && image.width > image.height) {
        img.Image rotatedImage = img.copyRotate(image, angle: 90);
        imageFile.writeAsBytesSync(img.encodeJpg(rotatedImage));
      }
      return imageFile;
    }
  } catch (e) {
    print('Error selecting image from camera: $e');
  }

  return null;
}
