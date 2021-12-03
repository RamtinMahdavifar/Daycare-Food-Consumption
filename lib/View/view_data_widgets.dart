import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';

Widget ViewDataOption(
    BuildContext context, String optionName, void Function() tapFunction) {
  //Button for view data page, button takes the current page context, button name and
  // the function to navigate to next page
  //PreCond:
  //          1. Requires context of current page,
  //          2. Button name as an string which should not be empty
  //          3. A function to perform if user clicks or taps the button
  //PostCond:
  //          1. Button is displayed on the page
  //          2. On press the button takes the user to the next page which was passed initially in arguments

  //Assertions to check if button name is not empty
  assert(optionName.isNotEmpty);

  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  return Card(
      child: SizedBox(
          width: screenWidth * 0.625,
          height: screenHeight * 0.15,
          child: ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            tileColor: Colors.green,
            title: Center(child: Text(optionName)),
            onTap: () {
              Config.log.i("User selected the option: $optionName");
              tapFunction();
            },
          )));
}
