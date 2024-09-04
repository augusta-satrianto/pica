import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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

String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}

Future<Uint8List> compressUintList(Uint8List list) async {
  var result = await FlutterImageCompress.compressWithList(
    list,
    minHeight: 1920,
    minWidth: 1080,
    quality: 30,
  );
  return result;
}

Color hexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex';
  }
  int colorInt = int.parse(hex, radix: 16);
  return Color(colorInt);
}

Color hexToGradient(String hex, [double blendAmount = 0.5]) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex';
  }
  int colorInt = int.parse(hex, radix: 16);
  Color baseColor = Color(colorInt);
  Color whiteColor = Colors.white;
  int red = ((1 - blendAmount) * baseColor.red + blendAmount * whiteColor.red)
      .toInt();
  int green =
      ((1 - blendAmount) * baseColor.green + blendAmount * whiteColor.green)
          .toInt();
  int blue =
      ((1 - blendAmount) * baseColor.blue + blendAmount * whiteColor.blue)
          .toInt();
  return Color.fromARGB(baseColor.alpha, red, green, blue);
}
