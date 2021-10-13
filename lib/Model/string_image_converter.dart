import 'dart:typed_data';
import 'dart:io';
// package necessary to check MIME types of files
import 'package:mime/mime.dart';
import 'dart:convert';

String convertImageToString(String imageFilePath){
  // input file path must refer to some file that actually exists
  assert(File(imageFilePath).existsSync());
  // input file must be an image, check MIME type of file
  assert(lookupMimeType(imageFilePath)!.startsWith('image/'));

  // read the input image file in as a sequence of bytes
  Uint8List imageFileBytes = File(imageFilePath).readAsBytesSync();

  // convert these bytes to a string using a base64 encoding
  String imageString = base64Encode(imageFileBytes);
  return imageString;
}