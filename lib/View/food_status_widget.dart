import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

import '../Model/variables.dart';

Widget foodStatusButton(

    ///widget button to display the food status option
    ///PreCond:
    ///          1. Requires context of current page,
    ///          2. Button name as an string which should not be empty
    ///          3. Page function to navigate to the next page
    ///
    ///PostCond:
    ///         1. Button is displayed on the page
    ///          2. On press the button takes the user to the next page which was passed initially in arguments

    BuildContext context,
    String btnName,
    Widget Function() page) {
  assert(btnName.isNotEmpty);

  return Flexible(
      child: Padding(
    padding: EdgeInsets.all(10),
    child: ElevatedButton(
      onPressed: () {
        Config.log.v("User clicked: " + btnName);
        setStatusVar(btnName);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return page();
        }));
      },
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          textStyle:
              const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      child: Text(
        btnName,
        style: TextStyle(
          // fontSize:40.0,
          fontSize: ResponsiveFlutter.of(context)
              .fontSize(4), // insert your font size here
        ),
      ),
    ),
  ));
}
