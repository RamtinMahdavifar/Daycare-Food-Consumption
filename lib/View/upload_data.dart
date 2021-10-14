import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
//import 'upload_data_widgets.dart';
import 'dart:convert';

class UploadData extends StatefulWidget {

  const UploadData({Key? key}) : super(key: key);

  @override
  State<UploadData> createState() => _UploadDataState();
}


class _UploadDataState extends State<UploadData>{

  List<XFile>? _imageFileList;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }
  dynamic _pickImageError;
  //String? _retrieveDataError;
  bool _showButton = true;
  final ImagePicker _picker = ImagePicker();

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {

    await _displayPickImageDialog(context!, () async {
          try {
            final pickedFile = await _picker.pickImage(source: source);
            setState(() {
              _imageFile = pickedFile;
              //hideButton();
            });
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
    });
  }

    //TODO: make this thing looks prettier and add a button for submitting the data or selecting a different image, then imporove the look for when the keyboard comes up
  Widget addComments() {
    return const TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Comments'
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

  Widget clearImage(){
    return ElevatedButton(
      child: const Text("Clear Image"),
      onPressed: (){
        setState(() {
          _imageFile = null;
          hideButton();
        });
      },
    );

  }
  Widget _previewImages() {
    //final Text? retrieveError = _getRetrieveErrorWidget();
/*    if (retrieveError != null) {
      return retrieveError;
    }*/
    if (_imageFileList != null) {
      hideButton();
      return Container( //semantics
          child: ListView.builder(
            key: UniqueKey(),
            itemBuilder: (context, index) {
              return Semantics(
                label: 'image_picker_example_picked_image',
                child: //kIsWeb
                    //? Image.network(_imageFileList![index].path)
                    Image.file(File(_imageFileList![index].path)), // : removed at start of line
              );
            },
            itemCount: _imageFileList!.length, //this line prevents an error when loading the image, just keep it
          ));
          //label: 'image_picker_example_picked_images');
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

 /* Widget _handlePreview() {
    return _previewImages();
  }
*/
  void hideButton(){
    setState((){
      _showButton = !_showButton;
    });
  }

/*  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {

      setState(() {
        _imageFile = response.file;
        _imageFileList = response.files;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Data"),
      ),
      body: _previewImages(), //Center(
        //child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
           /* ? FutureBuilder<void>(
          future: retrieveLostData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Text(
                  'You have not yet picked an image.',
                  textAlign: TextAlign.center,
                );
              case ConnectionState.done:
                return _handlePreview();
              default:
                if (snapshot.hasError) {
                  return Text(
                    'Pick image/video error: ${snapshot.error}}',
                    textAlign: TextAlign.center,
                  );
                } else {
                  return const Text(
                    'You have not yet picked an image.',
                    textAlign: TextAlign.center,
                  );
                }
            }
          },
        )*/
            //: _handlePreview(),
      //),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            child:addComments(),
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
          ),
          Row(
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  child: Visibility(
                    visible: _showButton,
                    child: ElevatedButton(
                      onPressed: () {
                        _onImageButtonPressed(ImageSource.gallery, context: context);
                      },
                      child: const Icon(Icons.photo),
                    ),
                  ),
                )

              ),
              Flexible(
                fit: FlexFit.tight ,
                child: Container(
                  child:Visibility(
                    visible: _showButton,
                    child: ElevatedButton(
                      onPressed: () {
                        _onImageButtonPressed(ImageSource.camera, context: context);
                      },
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                )

              )
            ]
          ),
          Row(
              children: <Widget>[
                Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      child: Visibility(
                        visible: !_showButton,
                        child: clearImage()
                      ),
                    )

                ),
                Flexible(
                    fit: FlexFit.tight ,
                    child: Container(
                      child:Visibility(
                        visible: !_showButton,
                        child: submitImage()
                      ),
                    )

                )
              ]
          )

        ],
      ),
    );
  }

/*  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }*/

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {onPick();}
}


typedef void OnPickImageCallback();

