import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart'; // need to include for the Event data type
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_screenshot/flutter_native_screenshot.dart';
import 'package:image/image.dart'
    as image; // import this package with the name image to avoid naming collisions
import 'package:image/image.dart' as i;
import 'package:path_provider/path_provider.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Model/database.dart';
import 'package:plate_waste_recorder/Model/food_status.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Model/meal.dart';
import 'package:plate_waste_recorder/Model/meal_info.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';
import 'package:plate_waste_recorder/Model/string_image_converter.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Model/database.dart';
import 'package:firebase_database/firebase_database.dart'; // need to include for the Event data type
import 'package:image/image.dart' as i;

import 'dart:convert';
import 'dart:io';

import 'name_suggest.dart';



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
  final weightTextController = new TextEditingController();
  final commentsTextController = new TextEditingController();

  // store the currently selected existing food item the user wants to modify or enter
  // new data for if the user isn't entering in an entirely new food item
  MealInfo selectedExistingFoodItem = null as MealInfo;

  List<String> FoodItems1 = ["Apple", "Sandwich", "Juice"]; //for String foodItem in existingFoodItems for eaten status
  List<String> Selected1 = []; //items that get selected once are not suggested again for eaten status
  List<String> FoodItems2 = ["Apple", "Sandwich", "Juice"]; //for String foodItem in existingFoodItems for container status
  List<String> Selected2 = []; //items that get selected once are not suggested again for container status

  Directory? directory;

  //XFile? _imageFile;
  // assume our input fields are valid by default
  bool _foodNameValid = true;
  bool _foodWeightValid = true;
  bool _foodCommentsValid = true;
  bool _previousFoodItemSelected = true;

  @override
  void initState() {
    super.initState();
    getPath();
    //run this on initial start to create the folder

  }

  @override
  Widget build(BuildContext context) {
    Config.log.i("Opening image submit dialog");
    // we must be submitting an entirely new food item and not adding eaten or container data
    // for an existing food item if the food status is uneaten
    bool newFoodSubmission = widget.currentFoodStatus == FoodStatus.uneaten;
    double w = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.fromLTRB(w / 2, 37, 0, 30),
        child: Dialog(
            elevation: 0,
            child: Form(
                child: Scaffold(
                    body: Center(
                        child: Column(
                          children: [
                            //nameEntrySuggester(nameTextController, _nameFoodValid),
                            // if the user is entering a food for the first time, display a text field allowing
                            // new meal names to be input, otherwise the user must select between previously entered
                            // meals if they are entering a container or an eaten entry for an already served food
                            newFoodSubmission ? Column(children: [suggestBox(context, nameTextController, this._foodNameValid), itemPresets(nameTextController)])
                                : Column(children: [existingFoods(), Visibility(visible: !_previousFoodItemSelected, child: Text("No food item selected: please select a food item", style: TextStyle(color: Colors.redAccent, fontSize: 18.0)))]),
                            // likewise only display previously created preset items if we are entering a food item for
                            // the first time, additionally only display an error message indicating the user has not chosen a pre existing
                            // food item if they try to submit without selecting an existing item to submit
                            // data for if a container or eaten food item is being submitted
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

  Widget existingFoods() {
    // we can only display existing meal/food items to add new data to if we are in
    // either the container or eaten food state, otherwise we are viewing data or are
    // submitting new uneaten food items instead of adding data to make an uneaten food
    // item eaten or recording data for the container of an eaten food item
    assert(widget.currentFoodStatus == FoodStatus.eaten || widget.currentFoodStatus == FoodStatus.container);
    // determine the previous food status, as we can only enter eaten food values for a
    // meal which has already been submitted as uneaten, likewise we can only enter container
    // data for meals which have been submitted as eaten, so valid meals to add eaten data
    // to are uneaten meals and valid meals to add container data to are eaten meals
    FoodStatus previousFoodStatus;
    if(widget.currentFoodStatus == FoodStatus.eaten){
      previousFoodStatus = FoodStatus.uneaten;
    }
    else{
      // current food status must be the container status
      previousFoodStatus = FoodStatus.eaten;
    }

    return StreamBuilder<Event>(
        stream: Database().readSubjectMealInfosWithStatus(
            ResearchGroupInfo("testResearchGroupName"),
            widget.currentInstitution,
            widget.currentSubject,
            previousFoodStatus),
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.hasError) {
            Config.log.e(
                "errors occurred while reading meal infos with status ${widget.currentFoodStatus} from the database on food input page, error: " +
                    snapshot.error.toString());
            return Text("errors in database read occurred");
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                Config.log.w(
                    "connection state none when reading meal infos from the database");
                // display a loading animation here, this will continue until we are
                // able to connect to the database
                return Center(
                    child: CircularProgressIndicator(
                  value: null,
                  color: Colors.green,
                ));
                break;
              case ConnectionState.waiting:
                Config.log.i(
                    "connection state waiting when reading meal infos from the database");
                // include a waiting animation while we connect to the database
                // value: null here indicates that the progress animation will
                // continue forever, until we read data from the database
                return Center(
                    child: CircularProgressIndicator(
                  value: null,
                  color: Colors.green,
                ));
                break;
              case ConnectionState.active:
                Config.log.i(
                    "active connection state when reading meal infos from the database");
                DataSnapshot mealInfosSnapshot = snapshot.data!.snapshot;
                if (mealInfosSnapshot.value == null) {
                  // if the retrieved mealInfosSnapshot contains null ie
                  // doesn't have any data, there are no meal infos
                  // present on the database for the current subject
                  // display a message indicating this
                  Config.log.w(
                      "DataSnapshot has null value when reading meal infos from the database, ie no meal infos are present for the current subject");
                  return Center(
                      child: Text(
                          "No ${describeEnum(previousFoodStatus)} food items have yet been submitted",
                          style: TextStyle(fontSize: 24.0)));
                } else {
                  // otherwise we do have meal infos for the current subject on the database, display these
                  Config.log.i(
                      "Meal Infos present in DataSnapshot, displaying these");
                  Map<dynamic, dynamic> snapshotValueMap =
                      mealInfosSnapshot.value as Map<dynamic, dynamic>;
                  String encodedMap = jsonEncode(snapshotValueMap);
                  Map<String, dynamic> mealInfoMap =
                      json.decode(encodedMap) as Map<String, dynamic>;
                  // each key in this meal map is the ID of a meal, the corresponding
                  // value is the MealInfo object representing that meal, display each
                  // such MealInfo as a button in a row
                  List<Widget> mealInfoList = mealInfoMap.values.map((element) {
                    // first convert each element in our values list to a MealInfo object
                    MealInfo currentMealInfo = MealInfo.fromJSON(element);
                    // display each meal info as a button, when the user clicks this button
                    // store data for the selected meal info to be used later when data is
                    // submitted
                    return ChoiceChip(
                      // ensure we use a white font colour so our text can still be seen as
                      // the background colour of the chip changes based on selection
                      label: Text(currentMealInfo.name,
                          style:
                              TextStyle(color: Colors.white, fontSize: 20.0)),
                      backgroundColor: Colors.blue,
                      selectedColor: Colors.green,
                      selected: selectedExistingFoodItem == currentMealInfo,
                      onSelected: (bool selected) {
                        if(selected){
                          Config.log.i("user has selected meal with name: ${currentMealInfo.name} and ID: ${currentMealInfo.mealId} to input new data for");
                          setState((){
                            // we have selected this particular food item, change our state
                            // to reflect this
                            selectedExistingFoodItem = currentMealInfo;
                            _previousFoodItemSelected = true;
                          });
                        }
                      },
                  );
                }).toList();
                return Wrap(direction: Axis.horizontal, children: mealInfoList);
              }

            case ConnectionState.done:
              Config.log.i("connection state done when reading meal infos from the database");
              return Text("connection state done");
              break;
          }
        }
      });
  }

  String getInst() {
    return widget.currentInstitution.name;
  }

  String getSubjectID() {
    String id = widget.currentSubject.subjectId;
    return id.substring(3);
  }


  String getStatus(){
    String status = widget.currentFoodStatus.toString();
    return status.substring(11);
  }


  /// perform the image capture by screenshotting the whole screen, and then
  /// cropping and horizontally flipping the the captured screenshot, and then
  /// saving it with savePic with the filename determined by the ID, foodName
  /// and foodStatus
  Future<image.Image> takeShot(String foodName) async {
    String? path = await FlutterNativeScreenshot.takeScreenshot();
    String filename;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    image.Image capturedImage = image.decodePng(File(path!).readAsBytesSync())!; //encode the og image into IMG
    capturedImage = image.copyCrop(capturedImage, 5, 61, (width/2).toInt() - 5, (height - 139).toInt());
    // starting at coords 5,61, to cut off the appbar, and only get the left half, and dont grab bottom portion with capture button on it
    // appbar is 56 + size 5 border,

    filename = foodName+
        "/" +
        getSubjectID() +
        "_" +
        foodName +
        "_" +
        getStatus() +
        ".png";

    savePic(i.flipHorizontal(capturedImage),
        filename, foodName);
    Config.log.i("Image ${getSubjectID()}_${foodName}_${getStatus()}.png Saved!");
    return capturedImage;
  }

  /// locates the external storage location where images will be stored on the
  /// device and then creates an organized file directory for the
  /// institute and the ID if they do not yet exist
  void getPath() async {
    //this could be useful for an issue i was running into with converting a csv to a List
    //use below line to create a directory for the cropped images
    directory = await getExternalStorageDirectory();

    Config.log.i("External Save Path: $directory");

    String newPath = "";

    List<String> paths = directory!.path.split("/");

    for (int x = 1; x < paths.length; x++) {
      String folder = paths[x];
      newPath += "/" + folder;
    }
    if (getInst()!=null && getSubjectID()!=null) {
      newPath = newPath + "/" + getInst() + "/" + getSubjectID();
      directory = Directory(newPath);
      Config.log.i("Using Current Path: ${directory!.path}");
    }
  }

  /// for each ID, this creates a new directory for every new food item submitted
  /// takes in a String of the name of the new food item that was entered
  Future<int> newPath(String foodname) async {
    Directory newDir;
    String newPath = "";
    List<String> paths = directory!.path.split("/");

    for (int x = 1; x < paths.length; x++) {
      String folder = paths[x];
      newPath += "/" + folder;
    }

    if (foodname!=null && directory != null) {
      newPath = newPath + "/" + foodname;
      newDir = Directory(newPath);

      if (!await newDir.exists()) {
        await newDir.create(recursive: true);
        Config.log.i("New Path Created: ${newDir.path}");
      }
      return 1;
    } else {
      Config.log.i("null foodName");
    }
    return 0;
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

  /// stores an image to the local device in a specified location set by
  /// getPath() + newPath(), takes an Image that is stored with the name filename
  void savePic(i.Image pic, String fileName, String foodName) async {
    if (directory != null) {
      if (!await directory!.exists()) {
        await directory!.create(recursive: true);
      }
      if (await directory!.exists()) {
        await newPath(foodName) == 1
        //make new path
            ? File(directory!.path + "/" + fileName)
            .writeAsBytesSync(i.encodePng(pic))
            : Config.log.i("new path not created");
      }
    } else {
      Config.log.i("no directory chosen");
    }
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

            // ensure the user has selected a previous food item if they are submitting
            // either container or eaten food data
            this._previousFoodItemSelected = this.selectedExistingFoodItem != null;
          });

          if(widget.currentFoodStatus == FoodStatus.uneaten){
            // we are submitting an entirely new food item
            if(this._foodNameValid && this._foodWeightValid && this._foodCommentsValid){
              Config.log.i("submitting entirely new uneaten meal with name: $inputName, weight: $inputWeight, and comments: $inputComments");
              // our fields are valid, submit the input data to the database
              // get the image the user has submitted
              takeShot(inputName).then((capturedImage){
                // convert our image to a string
                String imageString = convertImageToString(capturedImage);
                // construct a meal using the data we've collected and write this to our database
                Meal submittedMeal = Meal(inputName, widget.currentFoodStatus,
                    imageString, double.parse(inputWeight), inputComments);
                Database().addMealToSubject(
                    ResearchGroupInfo("testResearchGroupName"),
                    widget.currentInstitution,
                    widget.currentSubject,
                    submittedMeal);
              });

              // display a snackbar indicating data has been saved successfully
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Food Item Submitted Successfully")),
              );

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
          }
          else{
            // we are submitting either a container or eaten food item for an already existing meal
            if(this._previousFoodItemSelected && this._foodWeightValid && this._foodCommentsValid){
              // our meal submission is valid, submit our data
              Config.log.i("submitting new meal of status ${widget.currentFoodStatus.toString()} with existing name: ${this.selectedExistingFoodItem.name}, "
                  " and ID ${this.selectedExistingFoodItem.mealId}, weight: $inputWeight, and comments: $inputComments");
              // our fields are valid, submit the input data to the database
              // get the image the user has submitted
              takeShot(this.selectedExistingFoodItem.name).then((capturedImage){
                // convert our image to a string
                String imageString = convertImageToString(capturedImage);
                // construct a meal using the data we've collected and write this to our database
                // since we're merely adding a new entry with a different status to an existing meal,
                // this new Meal object will have the same ID and name as the previously selected meal
                Meal submittedMeal = Meal.fromExistingID(
                    this.selectedExistingFoodItem.name,
                    widget.currentFoodStatus,
                    imageString,
                    double.parse(inputWeight),
                    inputComments,
                    this.selectedExistingFoodItem.mealId);
                Database().addMealToSubject(
                    ResearchGroupInfo("testResearchGroupName"),
                    widget.currentInstitution,
                    widget.currentSubject,
                    submittedMeal);
              });

              // display a snackbar indicating data has been saved successfully
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Food Item Submitted Successfully")),
              );

              // clear our text fields before returning to the previous screen after data submit
              this.nameTextController.clear();
              this.weightTextController.clear();
              this.commentsTextController.clear();

              // return to the previous screen/close this popup dialog
              Navigator.of(context, rootNavigator: true).pop();
            }
          }
        },
        child: const Text("Submit"),
        style: ElevatedButton.styleFrom(primary: Colors.lightGreen));
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
    return Row(children: presets);
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
