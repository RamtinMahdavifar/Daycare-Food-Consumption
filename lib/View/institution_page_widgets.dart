import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/icons.dart';

Widget backButton(BuildContext context) {
  //Button to navigate to the previous page
  //PreCond:
  //          1. Current page context (not null) should be passed
  //
  //PostCond:
  //
  //          1. On press the button takes the user to the previous page
  return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(Icons.arrow_back));
}

Widget modifyButton() {
  //edit button to modify the content
  //PreCond:
  //          NA
  //
  //PostCond:
  //
  //          1. On press the button takes the user to edit page
  return InkWell(onTap: () {}, child: Icon(Icons.edit));
}

Widget menuButton(BuildContext context, String btnName, Widget Function() page,
    int iconIndex, {bool WIP = false}) {
  //menu button to display various options (Roster, presets, view data) under the institution page
  //PreCond:
  //          1. Requires context of current page,
  //          2. Button name as an string which should not be empty
  //          3. Page function to navigate to the next page
  //          4. iconIndex to display the appropriate icon for the menu option
  //PostCond:
  //          1. Button is displayed on the page
  //          2. On press the button takes the user to the next page which was passed initially in arguments

  assert(btnName.isNotEmpty);
  assert(iconIndex >= 0);

  return Flexible(
      child: SizedBox(
          height: 150,
          width: 250,
          child: ElevatedButton(
              onPressed: () {
                if (WIP){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: const Duration(seconds: 2),content: Text(
                      "Work in Progress")));
                }else{
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return page();
                  }));
                }

              },
              child: Column(children: <Widget>[
                Text(
                  btnName,
                  style: TextStyle(
                    fontSize: 40.0, // insert your font size here
                  ),
                ),
                Icon(
                  categories[iconIndex].icon,
                  color: Colors.orange,
                  size: 50.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                )
              ]))));
}
