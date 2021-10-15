import 'package:flutter/material.dart';
import 'upload_data.dart';
import 'dart:io';
//currently unsure how to get around certain widgets needing access to the setState function which can only be used within the statless class in the other file

//TODO: make this thing looks prettier and add a button for submitting the data or selecting a different image, then imporove the look for when the keyboard comes up
Widget addComments() {
  return const TextField(
    decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Comments'
    ),
  );
}

Widget addWeight() {
  return const TextField(
    decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Weight'
    ),
  );
}

Widget submitImage(){
  return ElevatedButton(
      child: const Text("Submit Data"),
      onPressed: (){//TODO upload image and comments to db

      }
    // ,
  );
}

Widget clearImage(_imageFile, btn){
  return ElevatedButton(
    child: const Text("Clear Image"),
    onPressed: (){
/*        setState(() {
          _imageFile = null;
          hideButton();
        });*/
      _imageFile = null;
      //hideButton(btn);

    },
  );

}

Widget previewImages(_imageFileList, btn) {
  if (_imageFileList != null) {
    //hideButton(btn);
    return Container( //semantics
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: Image.file(File(_imageFileList![index].path)),
            );
          },
          itemCount: _imageFileList!.length, //this line prevents an error when loading the image, just keep it
        )
    );

  } else {
    return const Text(
      'You have not yet picked an image.',
      textAlign: TextAlign.center,
    );
  }
}