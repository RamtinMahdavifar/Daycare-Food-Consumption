import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
//import 'upload_data_widgets.dart';
import 'dart:convert';
import 'package:plate_waste_recorder/Model/meal.dart';
import 'package:plate_waste_recorder/Model/database.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';
import 'package:plate_waste_recorder/Helper/config.dart';

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
  bool _showButton = true;
  final ImagePicker _picker = ImagePicker();

  TextEditingController _weightFieldController = TextEditingController();
  TextEditingController _commentFieldController = TextEditingController();
  TextEditingController _mealNameFieldController = TextEditingController();

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    Config.log.i("image button pressed, waiting for user to choose image from source: " + source.toString());

    await _displayPickImageDialog(context!, () async {
          try {
            final pickedFile = await _picker.pickImage(source: source);
            setState(() {
              _imageFile = pickedFile;
              Config.log.i("user selected file with path: " + pickedFile!.path);
            });

          } catch (e) {
            Config.log.e("error occurred while picking image, error: " + e.toString());
            setState(() {
              _pickImageError = e;
            });
          }
    });
  }

    // TODO: possibly consider having camera button in the middle of the screen if an image hasn't been selected
    // TODO: and then have a submit button always at the bottom to allow users to submit meals without a picture to save time
    //TODO: make this thing looks prettier and add a button for submitting the data or selecting a different image, then imporove the look for when the keyboard comes up
  Widget addComments() {
    return TextField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Comments'
      ),
      controller: this._commentFieldController,
    );
  }

  Widget addWeight() {
    return TextField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Weight',
      ),
        controller: this._weightFieldController,
        // specify that a digit keyboard should be used, signed values should not be
        // allowed and decimals should be enabled
        keyboardType: TextInputType.numberWithOptions(signed: false, decimal:true),
        // specify an input formatter to ensure our values are in the specified format
        // here we require at least 1 digit before any decimals, and allow any number
        // of digits (including 0) following a decimal if one exists, we must allow
        // 0 digits after the decimal or else the user will be unable to type a decimal
        // as the field will always require a digit after the '.' and the user can only
        // type one character at a time
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d*)?'))
        ]
    );
  }

  Widget addMealName(){
    return TextField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Name'
      ),
      controller: this._mealNameFieldController,
    );
  }

  Widget submitImage(){
    return ElevatedButton(
      child: const Text("Submit Data"),
      onPressed: (){
        Config.log.i("user clicked button to submit meal data");
        // we require the user to have chosen an image before allowing them to submit
        // their data
        // TODO: use firebase push() functionality to generate a unique ID for meals, consider using this in meal constructor
        Meal newMeal = Meal("test meal ID");
        // add the submitted image to this meal
        // assume this is a new meal
        // TODO: add UI and functionality to choose and add data to prexisting meals
        newMeal.beforeImageAsString = this._imageFileList![0].path;
        Config.log.i("writing the image with path: " + this._imageFileList![0].path + " to the database");
        // add weight, meal name, and comments to this Meal object if such fields are
        // filled in, here these fields are optional to aid in fast data entry
        String inputWeight = this._weightFieldController.value.text;
        if(inputWeight.isNotEmpty){
          // weight has been input, add to meal, the input string weight must be in
          // valid double format due to input restrictions on our weight field
          newMeal.beforeMealWeight = double.parse(inputWeight);
          Config.log.i("user has input meal weight: " + inputWeight);
        }
        String inputComment = this._commentFieldController.value.text;
        if(inputComment.isNotEmpty){
          // comment has been input, add to meal
          newMeal.comment = inputComment;
          Config.log.i("user has input comment: " + inputComment);
        }
        String inputMealName = this._mealNameFieldController.value.text;
        if(inputMealName.isNotEmpty){
          // meal name has been input, add to meal
          newMeal.mealName = inputMealName;
          Config.log.i("user has input meal name: " + inputMealName);
        }
        // all input data has been added to newMeal, write this to the database
        // write this meal to the database under a test research group as adding and joining
        // research groups is not yet implemented
        Config.log.i("writing newly created meal to database");
        Database().writeMealToDatabase(ResearchGroupInfo("testResearchGroupName"), newMeal);

        // after the new meal has been submitted, clear the data in the fields so
        // the user can submit other meals
        Config.log.i("clearing the upload data page so the user can submit another meal");
        setState((){
          this._mealNameFieldController.clear();
          this._weightFieldController.clear();
          this._commentFieldController.clear();
          _imageFile = null;
          hideButton();
        });

        // finally display a snackbar informing the user their data has been submitted
        Config.log.i("displaying snackbar to user");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Data Submitted Successfully"))
        );

      }
        // ,
    );
  }

  Widget clearImage(){
    return ElevatedButton(
      child: const Text("Clear Image"),
      onPressed: (){
/*        setState(() {
          _imageFile = null;
          hideButton();
        });*/
        Config.log.i("image clear button pressed, clearing the user's selected image");
        _imageFile = null;
        hideButton();
      },
    );

  }
  Widget _previewImages() {
    if (_imageFileList != null) {
      hideButton();
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




  void hideButton(){
    setState((){
      _showButton = !_showButton;
    });

  }


  @override
  Widget build(BuildContext context) {
    Config.log.i("building upload data page");
    return Scaffold(
          appBar: AppBar(
            title: Text("Upload Data"),
          ),
          body: _previewImages(), //Center(
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child:addMealName(),
                padding: EdgeInsets.all(1),
                alignment: Alignment.center,
              ),
              Container(
                child:addWeight(),
                padding: EdgeInsets.all(1),
                alignment: Alignment.center,
              ),
              Container(
                child:addComments(),
                padding: EdgeInsets.all(1),
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

  @override
  void dispose(){
    this._weightFieldController.dispose();
    this._commentFieldController.dispose();
    this._mealNameFieldController.dispose();
    super.dispose();
  }


  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {onPick();}
}


typedef void OnPickImageCallback(); //this line allows it to be called in above function

