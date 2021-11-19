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

List<String> exampleFoodItems = ["Apple", "Sandwich", "Juice"]; //for String foodItem in exampleFoodItems
final nameTextController = new TextEditingController();
final weightTextController = new TextEditingController(text: "69"); //this value of text would be the value returned by our scale
final commentsTextController = new TextEditingController();

//XFile? _imageFile;
bool _nameFoodValid = true;
bool _weightFoodValid = true;
//final _newFoodItemKey = GlobalKey<FormState>();
@override
//change foodScannedFirst to build when reformatting the code
// TODO: this should be a class extending stateful widget so text controllers can be a part of widget state
Widget foodScannedFirst(BuildContext context, QRViewController controller) {
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
                        //nameEntrySuggester(nameTextController, _nameFoodValid),
                        suggestBox(context, nameTextController, _nameFoodValid),
                        itemPresets(nameTextController),
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
    validator: (value) { // TODO: this form of validation does not work, ie this does nothing
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
    // TODO: in this text field the keyboard should be specified, user should only be able to enter decimal values
    controller: controller,
  );

}
