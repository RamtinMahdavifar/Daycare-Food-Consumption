import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
//Image.file(File(img!.path))


final nameTextController = new TextEditingController();
//XFile? _imageFile;
bool _nameFoodValid = true;
//final _newFoodItemKey = GlobalKey<FormState>();
@override
//change foodScannedFirst to build when reformatting the code
Widget foodScannedFirst(BuildContext context, XFile? imageFile) {
  return Dialog(
    child: Form(
      //key: _newFoodItemKey,
      child: Scaffold(
        body: Row(
          children: [
            Column(
              children: [
                Image.file(File(imageFile!.path)),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Retake Photo"),
                  style: ElevatedButton.styleFrom(primary: Colors.redAccent)
                ),
              ]
            ),
            Expanded(
              child: Column(
                children: [
                  nameEntrySuggester(context, nameTextController, _nameFoodValid),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Sumbit"),
                    style: ElevatedButton.styleFrom(primary: Colors.lightGreen))
                ],
              )
            )
          ]
        )
      )
    )
  );
}

Widget nameEntrySuggester(BuildContext context, TextEditingController controller, bool fieldIsValid){

  return TextFormField(
    validator: (value) {
      if (value == null || value.isEmpty){
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
    controller: controller,
  );

}
