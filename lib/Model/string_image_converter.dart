import 'dart:typed_data';
import 'dart:io';
// package necessary to check MIME types of files
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:plate_waste_recorder/Helper/config.dart';

String convertImageToString(String imageFilePath){
  // input file path must refer to some file that actually exists
  assert(File(imageFilePath).existsSync());
  // input file must be an image, check MIME type of file
  assert(lookupMimeType(imageFilePath)!.startsWith('image/'));

  Config.log.i("converting image at path: " + imageFilePath + " to a base 64 encoded string");

  // read the input image file in as a sequence of bytes
  Uint8List imageFileBytes = File(imageFilePath).readAsBytesSync();

  // convert these bytes to a string using a base64 encoding
  String imageString = base64Encode(imageFileBytes);
  return imageString;
}

void convertStringToImage(String imageString, String resultingImageFilePath){
  // ensure our image string is not empty
  assert(imageString.isNotEmpty);
  // ensure the resulting file path is greater than 4 characters as this file path
  // must contain a file extension for example .png, .jpg, .jpeg, etc all of which
  // are at least 4 characters, so a valid filename requires these 4 characters and
  // one more character ahead of the file extension
  assert(resultingImageFilePath.length>4);

  // TODO: could check and see if file already exists to prevent overwriting
  // TODO: check and see what happens if file doesn't exist and already exists
  // create a new file to store the string image at
  File destinationFile = File(resultingImageFilePath);

  // ensure that the file path provided refers to an image file
  assert(lookupMimeType(resultingImageFilePath)!.startsWith('image/'));

  // do not log the value of the input imageString, as these image strings are gigantic in size
  Config.log.i("converting image string to image at destination path: " + resultingImageFilePath);

  // convert our base 64 image string into raw bytes of data
  Uint8List imageBytes = base64Decode(imageString);

  // write the bytes we've decoded into an image file
  destinationFile.writeAsBytesSync(imageBytes);
}