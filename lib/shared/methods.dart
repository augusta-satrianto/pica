import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

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

Future<File?> selectImageCamera() async {
  final ImagePicker _picker = ImagePicker();

  try {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800, // Optional: Set maksimum lebar gambar
      maxHeight: 600, // Optional: Set maksimum tinggi gambar
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
  } catch (e) {
    print('Error selecting image from camera: $e');
  }

  return null;
}

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
