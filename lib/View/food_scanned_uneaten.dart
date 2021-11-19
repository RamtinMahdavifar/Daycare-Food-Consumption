
import 'package:image/image.dart' as image; // import this package with the name image to avoid naming collisions
import 'package:flutter_native_screenshot/flutter_native_screenshot.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'name_suggest.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/rendering.dart';
import "../Model/variables.dart";
import 'package:plate_waste_recorder/Helper/config.dart';
import 'dart:io';


class UneatenFoodDialog extends StatefulWidget {

  // take as parameters to this page the institution and subject info this meal belongs under
  InstitutionInfo currentInstitution;
  SubjectInfo currentSubject;
  UneatenFoodDialog(this.currentInstitution, this.currentSubject, {Key? key}) : super(key: key);


  @override
  _UneatenFoodDialogState createState() => _UneatenFoodDialogState();
}

class _UneatenFoodDialogState extends State<UneatenFoodDialog> {
  List<String> exampleFoodItems = ["Apple", "Sandwich", "Juice"]; //for String foodItem in exampleFoodItems
  final nameTextController = new TextEditingController();
  final weightTextController = new TextEditingController(text: "69"); //this value of text would be the value returned by our scale
  final commentsTextController = new TextEditingController();

  //XFile? _imageFile;
  // assume our input fields are valid by default
  bool _foodNameValid = true;
  bool _foodWeightValid = true;
  bool _foodCommentsValid = true;


  @override
  Widget build(BuildContext context) {
    Config.log.i("Opening image submit dialog");
    //widget.qrViewController.resumeCamera();
    //widget.qrViewController.pauseCamera();

    //controller.pauseCamera();
    double w = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.fromLTRB(w/2, 37, 0, 30), // bottom 30, top 37, these are precision measurements for all screens btw
        child:Dialog(
            elevation: 0,
            child: Form(
              //key: _newFoodItemKey,
                child: Scaffold(
                    body:
                    Center(
                        child: Column(
                          children: [
                            //nameEntrySuggester(nameTextController, _nameFoodValid),
                            suggestBox(context, nameTextController, this._foodNameValid),
                            itemPresets(nameTextController),
                            foodEntry(weightTextController, "Weight(g)", this._foodWeightValid),
                            foodEntry(commentsTextController, "Comments", this._foodCommentsValid),
                            submitData(),
                            retakePhoto(),
                          ],
                        )
                    )
                )
            )
        )
    );
  }


  /// perform the image capture by screenshotting the whole screen, and then
  /// cropping and horizontally flipping the the captured screenshot, and then
  /// saving it with savePic with the filename determined by the ID, foodName
  /// and foodStatus
  Future<image.Image> takeShot() async {
    String? path = await FlutterNativeScreenshot.takeScreenshot();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    image.Image capturedImage = image.decodePng(File(path!).readAsBytesSync())!; //encode the og image into IMG
    capturedImage = image.copyCrop(capturedImage, 5, 61, (width/2).toInt() - 5, (height - 139).toInt());
    // starting at coords 5,61, to cut off the appbar, and only get the left half, and dont grab bottom portion with capture button on it
    // appbar is 56 + size 5 border,
    return capturedImage;
  }

  Widget retakePhoto(){
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: const Text("Retake Photo"),
        style: ElevatedButton.styleFrom(primary: Colors.redAccent)
    );
  }

  Widget submitData(){
    return ElevatedButton(
        onPressed: () {
          //submit name - weight - ID - photo - comments - date - institution

          Config.log.i("User has pressed button to submit meal data");
          // extract relevant data from our fields for data submit
          String inputName = this.nameTextController.value.text;
          String inputWeight = this.weightTextController.value.text;
          String inputComments = this.commentsTextController.value.text;

          setState((){
            // check whether our fields are valid
            this._foodNameValid = inputName.isNotEmpty;
            this._foodWeightValid = inputWeight.isNotEmpty;
            this._foodCommentsValid = inputComments.isNotEmpty;
          });

          if(this._foodNameValid && this._foodWeightValid && this._foodCommentsValid){
            // our fields are valid, submit the input data to the database
            // get the image the user has submitted
            takeShot().then((capturedImage){
              capturedImage.getBytes();
            });


            // clear our text fields before returning to the previous screen after data submit
            this.nameTextController.clear();
            this.weightTextController.clear();
            this.commentsTextController.clear();

            // return to the previous screen/close this popup dialog
            Navigator.of(context, rootNavigator: true).pop();
          }
          else{
            Config.log.i("meal submission fields are not valid");
          }
        },
        child: const Text("Submit"),
        style: ElevatedButton.styleFrom(primary: Colors.lightGreen)
    );
  }

  Widget itemPresets(TextEditingController controller) {
    List<Widget> presets = [];
    for (String foodItem in exampleFoodItems){
      presets.add(
          ElevatedButton(
              onPressed: () {controller.text = foodItem;} ,
              child: Text(foodItem)
          )
      );
    }
    return Row(children : presets);
  }

  Widget nameEntrySuggester(TextEditingController controller, bool fieldIsValid) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: "Name of Food Item",
          // if the field isn't valid errorText has the value "Value Can't Be Empty"
          // otherwise errorText is null
          errorText: !fieldIsValid ? "Value Can't Be Empty" : null
      ),

    );

  }

  Widget foodEntry(TextEditingController controller, String fieldName, bool fieldIsValid){
    assert(fieldName.isNotEmpty);
    return TextFormField(
      decoration: InputDecoration(
          labelText: fieldName,
          // if the field isn't valid errorText has the value "Value Can't Be Empty"
          // otherwise errorText is null
          errorText: !fieldIsValid ? "Value Can't Be Empty" : null
      ),
      controller: controller,
    );
  }
}


