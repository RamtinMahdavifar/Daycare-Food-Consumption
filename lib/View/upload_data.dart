import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets.dart' as btn;
import 'dart:io';

class UploadData extends StatefulWidget {
  //String institutionName;
  //String institutionAddress;

  UploadData({Key? key}) : super(key: key);

  @override
  State<UploadData> createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Upload Data"), leading: btn.BackButton(context)),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
                children: [ //
                  btn.uploadImage(context),
                ])
        )
    );
  }
}

class ImageCapture extends StatefulWidget{
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture>{
  late File _imageFile;

  Future<void> _pickImage(ImageSource source) async{
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });

  }

  void _clear() {
    setState(() => _imageFile = null);
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera)
            ),
            IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: () => _pickImage(ImageSource.gallery)
            )

          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          if _imageFile != null ... [
            Image.file(_imageFile),
            Row(
              children: <Widget>[
                TextButton(
                  child: Icon(Icons.refresh),
                  onPressed: _clear,
                )
              ]

            )
          ]
        ]
      )

    );
  }
}

