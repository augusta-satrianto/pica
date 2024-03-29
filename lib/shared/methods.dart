import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image/image.dart' as img;

Future<XFile?> selectImage() async {
  XFile? selectedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  return selectedImage;
}

// Future<XFile?> selectImageCamera() async {
//   XFile? selectedImage =
//       await ImagePicker().pickImage(source: ImageSource.camera);
//   return selectedImage;
// }

// Future<File?> selectImageCamera() async {
//   var resultGambar = await FilePicker.platform.pickFiles(type: FileType.image);
//   File imageFile = File(resultGambar!.files.single.path.toString());

//   return imageFile;
// }

Future<File?> selectImageGalery() async {
  var resultGambar = await FilePicker.platform.pickFiles(type: FileType.image);
  File imageFile = File(resultGambar!.files.single.path.toString());

  return imageFile;
}

// Future<File?> selectImageCamera() async {
//   final ImagePicker _picker = ImagePicker();

//   try {
//     final XFile? pickedFile = await _picker.pickImage(
//       source: ImageSource.camera,
//       // maxWidth: 100, // Optional: Set maksimum lebar gambar
//       // maxHeight: 200, // Optional: Set maksimum tinggi gambar
//     );

//     if (pickedFile != null) {
//       return File(pickedFile.path);
//     }
//   } catch (e) {
//     print('Error selecting image from camera: $e');
//   }

//   return null;
// }

Future<File?> selectImageCamera() async {
  final ImagePicker _picker = ImagePicker();

  try {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      // Baca file gambar
      File imageFile = File(pickedFile.path);

      // Baca gambar menggunakan image package
      img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

      // Periksa orientasi gambar
      if (image != null && image.width > image.height) {
        // Jika lebar gambar lebih besar dari tinggi, maka perlu diputar
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

// Future<File?> selectImageCamera() async {
//   final ImagePicker _picker = ImagePicker();

//   try {
//     final XFile? pickedFile = await _picker.pickImage(
//       source: ImageSource.camera,
//     );

//     if (pickedFile != null) {
//       File rotatedImage = await FlutterExifRotation.rotateAndSaveImage(
//         path: pickedFile.path,
//       );
//       return rotatedImage;
//     }
//   } catch (e) {
//     print('Error selecting image from camera: $e');
//   }

//   return null;
// }

// File? _fileFile;
Future<FilePickerResult?> selectFile() async {
  FilePickerResult? resultFile = await FilePicker.platform.pickFiles(
      // type: FileType.custom, allowedExtensions: ['jpg', 'png', 'pdf']);
      type: FileType.custom,
      allowedExtensions: ['pdf']);
  return resultFile;
}

String? getStringFile(File? file) {
  if (file == null) return null;
  print(file);
  return base64Encode(file.readAsBytesSync());
}

Future<bool> cekFormatEmail(String email) async {
  // Pola regex untuk memeriksa format email
  RegExp regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

  // Memeriksa apakah string memiliki format email yang benar
  bool isValid = regex.hasMatch(email);

  // Menyimpan hasil validasi dalam variabel _isValidEmail

  return isValid;
}
