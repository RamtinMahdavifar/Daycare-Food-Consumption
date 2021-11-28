
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image; // import this package with the name image to avoid naming collisions
import 'package:flutter_native_screenshot/flutter_native_screenshot.dart';
import 'package:plate_waste_recorder/Model/meal.dart';
import 'package:plate_waste_recorder/Model/food_status.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';
import 'package:plate_waste_recorder/Model/string_image_converter.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'name_suggest.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/rendering.dart';
import "../Model/variables.dart";
import 'package:plate_waste_recorder/Helper/config.dart';
import 'dart:io';
import 'package:plate_waste_recorder/Model/database.dart';


class FoodInputDialog extends StatefulWidget {

  // take as parameters to this page the institution and subject info this meal belongs under
  InstitutionInfo currentInstitution;
  SubjectInfo currentSubject;
  FoodStatus currentFoodStatus;
  FoodInputDialog(this.currentInstitution, this.currentSubject, this.currentFoodStatus, {Key? key}) : super(key: key);


  @override
  _FoodInputDialogState createState() => _FoodInputDialogState();
}

class _FoodInputDialogState extends State<FoodInputDialog> {
  List<String> exampleFoodItems = ["Apple", "Sandwich", "Juice"]; //for String foodItem in exampleFoodItems
  final nameTextController = new TextEditingController();
  final weightTextController = new TextEditingController(text: "69"); //this value of text would be the value returned by our scale
  final commentsTextController = new TextEditingController();

  List<String> FoodItems1 = ["Apple", "Sandwich", "Juice"]; //for String foodItem in existingFoodItems for eaten status
  List<String> Selected1 = []; //items that get selected once are not suggested again for eaten status
  List<String> FoodItems2 = ["Apple", "Sandwich", "Juice"]; //for String foodItem in existingFoodItems for container status
  List<String> Selected2 = []; //items that get selected once are not suggested again for container status

  //XFile? _imageFile;
  // assume our input fields are valid by default
  bool _foodNameValid = true;
  bool _foodWeightValid = true;
  bool _foodCommentsValid = true;


  @override
  Widget build(BuildContext context) {
    Config.log.i("Opening image submit dialog");
    // we must be submitting an entirely new food item and not adding eaten or container data
    // for an existing food item if the food status is uneaten
    bool newFoodSubmission = widget.currentFoodStatus == FoodStatus.uneaten;
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
                            // if the user is entering a food for the first time, display a text field allowing
                            // new meal names to be input, otherwise the user must select between previously entered
                            // meals if they are entering a container or an eaten entry for an already served food
                            newFoodSubmission ? Column(children: [suggestBox(context, nameTextController, this._foodNameValid), itemPresets(nameTextController)])
                                : SizedBox(height: 30, child: existingFoods(nameTextController)),
                            // likewise only display previously created preset items if we are entering a food item for
                            // the first time
                            foodWeightField(weightTextController, "Weight(g)", this._foodWeightValid),
                            foodInputField(commentsTextController, "Comments", this._foodCommentsValid),
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


  Widget existingFoods(TextEditingController controller) {
    List<Widget> presets = [];
    if (widget.currentFoodStatus == FoodStatus.eaten){ // show remaining food items for eaten status
      for (String foodItem in FoodItems1){
        presets.add(
            ElevatedButton(
                onPressed: () {controller.text = foodItem;} ,
                child: Text(foodItem)
            )
        );
      }
    }else if (widget.currentFoodStatus == FoodStatus.container){ //show remaining food items for container status
      for (String foodItem in FoodItems2){
        presets.add(
            ElevatedButton(
                onPressed: () {controller.text = foodItem;} ,
                child: Text(foodItem)
            )
        );
      }
    }else {
      throw Exception("Invalid Food Status");
    }
    return ListView(scrollDirection: Axis.horizontal, children: presets);
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
            this._foodNameValid = inputName.isNotEmpty && inputName!=null;
            this._foodWeightValid = inputWeight.isNotEmpty && inputWeight!=null;
            // our comment field is optional and as such can be an empty string,
            // ensure this value is not null however
            this._foodCommentsValid = inputComments!=null;
          });

          if(this._foodNameValid && this._foodWeightValid && this._foodCommentsValid){
            // our fields are valid, submit the input data to the database
            // get the image the user has submitted
            takeShot().then((capturedImage){
              // convert our image to a string
              String imageString = convertImageToString(capturedImage);
              // construct a meal using the data we've collected and write this to our database
              Meal submittedMeal = Meal(inputName, widget.currentFoodStatus, imageString, double.parse(inputWeight), inputComments);
              Database().addMealToSubject(ResearchGroupInfo("testResearchGroupName"), widget.currentInstitution, widget.currentSubject, submittedMeal);
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

  Widget foodInputField(TextEditingController controller, String fieldName, bool fieldIsValid){
    assert(fieldName.isNotEmpty);
    return TextFormField(
      decoration: InputDecoration(
          labelText: fieldName,
          // if the field isn't valid errorText has the value "Value Can't Be Empty"
          // otherwise errorText is null
          errorText: !fieldIsValid ? "Value Can't Be Empty" : null,
      ),
      controller: controller,
    );
  }

  Widget foodWeightField(TextEditingController controller, String fieldName, bool fieldIsValid){
    assert(fieldName.isNotEmpty);
    return TextFormField(
      decoration: InputDecoration(
        labelText: fieldName,
        // if the field isn't valid errorText has the value "Value Can't Be Empty"
        // otherwise errorText is null
        errorText: !fieldIsValid ? "Value Can't Be Empty" : null,
      ),
      controller: controller,
      // specify that a digit keyboard should be used, signed values should not be
      // allowed and decimals should be enabled
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal:true),
      // specify an input formatter to ensure our values are in the specified format
      // here we require at least 1 digit before any decimals, and allow any number
      // of digits (including 0) following a decimal if one exists, we must allow
      // 0 digits after the decimal or else the user will be unable to type a decimal
      // as the field will always require a digit after the '.' and the user can only
      // type one character at a time
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d*)?'))]
    );
  }


  @override
  void dispose(){
    this.weightTextController.dispose();
    this.nameTextController.dispose();
    this.commentsTextController.dispose();
    super.dispose();
  }
}


