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
//Image.file(File(img!.path))

List<String> FoodItems1 = ["Apple", "Sandwich", "Juice"]; //for String foodItem in existingFoodItems for eaten status
List<String> Selected1 = []; //items that get selected once are not suggested again for eaten status
List<String> FoodItems2 = ["Apple", "Sandwich", "Juice"]; //for String foodItem in existingFoodItems for container status
List<String> Selected2 = []; //items that get selected once are not suggested again for container status
final nameTextController = new TextEditingController(text: "Select an Existing Food Item");
final weightTextController = new TextEditingController(text: "69"); //this value of text would be the value returned by our scale
final commentsTextController = new TextEditingController();

//XFile? _imageFile;
bool _nameFoodValid = true;
bool _weightFoodValid = true;
//final _newFoodItemKey = GlobalKey<FormState>();
@override

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
                          weightEntry(weightTextController, _weightFoodValid),
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
