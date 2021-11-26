import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'name_suggest.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/rendering.dart';
import "../Model/variables.dart";
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_native_screenshot/flutter_native_screenshot.dart';
import 'package:image/image.dart' as image; // import this package with the name image to avoid naming collisions
import 'package:plate_waste_recorder/Model/meal.dart';
import 'package:plate_waste_recorder/Model/food_status.dart';
import 'package:plate_waste_recorder/Model/string_image_converter.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
//Image.file(File(img!.path))



class EatenFoodDialog extends StatefulWidget {

  // take as parameters to this page the institution and subject info this meal belongs under
  InstitutionInfo currentInstitution;
  SubjectInfo currentSubject;
  FoodStatus currentFoodStatus;
  EatenFoodDialog(this.currentInstitution, this.currentSubject, this.currentFoodStatus, {Key? key}) : super(key: key);


  @override
  _EatenFoodDialogState createState() => _EatenFoodDialogState();
}

class _EatenFoodDialogState extends State<EatenFoodDialog> {
  List<String> FoodItems1 = ["Apple", "Sandwich", "Juice"]; //for String foodItem in existingFoodItems for eaten status
  List<String> Selected1 = []; //items that get selected once are not suggested again for eaten status
  List<String> FoodItems2 = ["Apple", "Sandwich", "Juice"]; //for String foodItem in existingFoodItems for container status
  List<String> Selected2 = []; //items that get selected once are not suggested again for container status
  final nameTextController = new TextEditingController(text: "Select an Existing Food Item");
  final weightTextController = new TextEditingController(text: "69"); //this value of text would be the value returned by our scale
  final commentsTextController = new TextEditingController();

  bool _foodNameValid = true;
  bool _foodWeightValid = true;
//final _newFoodItemKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    Config.log.i("Opening image submit dialog");

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







































































/// the dialog for entering the data of an image that was caputed.
Widget foodScannedSecond(BuildContext context, QRViewController controller) {
  print("Image submit dialog opens");
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
                          Text(nameTextController.text),
                          //nameEntrySuggester(nameTextController, _nameFoodValid),
                          //suggestBox(context, nameTextController, _nameFoodValid),
                          existingFoods(nameTextController),
                          weightEntry(weightTextController, _foodWeightValid),
                          addComments(context, commentsTextController),
                          submitData(context, controller, nameTextController, weightTextController, commentsTextController),
                          retakePhoto(context, controller),
                        ],
                      )
                  )
              )
          )
      )
  );

}

Widget retakePhoto(BuildContext context, QRViewController controller){
  return ElevatedButton(
      onPressed: () {
        controller.resumeCamera();
        Navigator.of(context, rootNavigator: true).pop();
      },
      child: const Text("Retake Photo"),
      style: ElevatedButton.styleFrom(primary: Colors.redAccent)
  );
}

Widget submitData(BuildContext context, QRViewController controller, TextEditingController n, TextEditingController w, TextEditingController c){
  return ElevatedButton(
      onPressed: () {
        //submit name - weight - ID - photo - comments - date - institution
        controller.resumeCamera();
        Navigator.of(context, rootNavigator: true).pop();
        setFoodVars(n.text, w.text, c.text);
        n.clear();
        w.clear();
        c.clear();

      },
      child: const Text("Submit"),
      style: ElevatedButton.styleFrom(primary: Colors.lightGreen)
  );
}

Widget addComments(BuildContext context, TextEditingController controller) {
  return TextField(
    decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Comments'
    ),
    controller: controller,
  );
}

Widget existingFoods(TextEditingController controller) {
  List<Widget> presets = [];
  if (getStatus() == "eaten"){ // show remaining food items for eaten status
    for (String foodItem in FoodItems1){
      presets.add(
          ElevatedButton(
              onPressed: () {controller.text = foodItem;} ,
              child: Text(foodItem)
          )
      );
    }
  }else if (getStatus() == "container"){ //show remaining food items for container status
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
  return Row(children : presets);
}

Widget nameEntrySuggester(TextEditingController controller, bool fieldIsValid) {
  return TextFormField(
    controller: controller,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'missing fields';
      }
      return null;
    },
    decoration: InputDecoration(

        labelText: "Name of Food Item",
        // if the field isn't valid errorText has the value "Value Can't Be Empty"
        // otherwise errorText is null
        errorText: !fieldIsValid ? "Value"
            "Can't Be Empty" : null
    ),

  );

}

Widget weightEntry(TextEditingController controller, bool fieldIsValid){

  return TextFormField(
    validator: (value) {
      if (value == null || value.isEmpty){
        return 'missing fields';
      }
      return null;
    },
    decoration: InputDecoration(

        labelText: "Weight (g)",
        // if the field isn't valid errorText has the value "Value Can't Be Empty"
        // otherwise errorText is null
        errorText: !fieldIsValid ? "Value"
            "Can't Be Empty" : null
    ),
    controller: controller,
  );

}
