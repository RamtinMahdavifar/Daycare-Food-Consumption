import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:plate_waste_recorder/Helper/qr_code_exporter.dart';

Widget RosterRecord(BuildContext context, String btnName,
    Widget Function() page, String StudentID) {
  //It displays a student record in a row format with student id and
  // methods available to perform over record like view, edit and delete.
  //PreCond:
  //          1. Requires context of current page,
  //          2. Button name as an string which should not be empty
  //          3. Page function to navigate to the next page
  //
  //PostCond:
  //          1. Button is displayed on the page
  //          2. On press the button takes the user to the next page which was passed initially in arguments
  assert(btnName.isNotEmpty);
  assert(StudentID.isNotEmpty);
  return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.blueAccent, style: BorderStyle.solid, width: 5.0)),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        ElevatedButton(
          //Remove student record button
          onPressed: () {
            Config.log.v("User clicked to remover the record for " + StudentID);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return page();
            }));
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            primary: Colors.red,
          ),

          child: Icon(
            Icons.highlight_remove,
            color: Colors.black,
            size: 60.0,
          ),
        ),
        SizedBox(width: 200)
        // add an empty SizedBox between column elements
        // to create space between elements
        ,
        //Text to display the student/QR ID
        Text(StudentID, style: TextStyle(fontSize: 40)),

        SizedBox(width: 200),
        // add an empty SizedBox between column elements
        // to create space between elements

        ElevatedButton(
          //QR code button to open QR for a particular student
          onPressed: () {
            Config.log.v("User clicked OR code button for " + StudentID);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return page();
            }));
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              textStyle:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          child: Icon(
            Icons.qr_code,
            color: Colors.black,
            size: 60.0,
          ),
        ),

        SizedBox(width: 180), // add an empty SizedBox between column elements
        // to create space between elements

        ElevatedButton(
          //Button to edit and view the student record
          onPressed: () {
            Config.log.v("User clicked edit button for " + StudentID);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return page();
            }));
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              textStyle:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          child: Icon(
            Icons.mode_edit,
            color: Colors.black,
            size: 60.0,
          ),
        )
      ]));
}

Widget addNewId(BuildContext context, String btnName, Widget Function() page) {
  //Button to add new Id in the roster
  //PreCond:
  //          1. Requires context of current page,
  //          2. Button name as an string which should not be empty
  //          3. Page function to navigate to the next page
  //
  //PostCond:
  //          1. Add new id Button is displayed on the page
  //          2. On press the button invokes method to add new id in the roster

  assert(btnName.isNotEmpty);
  return Flexible(
      child: SizedBox(
          height: 100,
          width: 650,
          child: ElevatedButton(
              onPressed: () {
                Config.log
                    .i("User clicked on addNewId button named: " + btnName);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //TODO: Implement the backend code for adding a new id into the institution
                  return page();
                }));
              },
              child: Row(children: <Widget>[
                Text(
                  btnName,
                  style: TextStyle(
                    fontSize: ResponsiveFlutter.of(context)
                        .fontSize(4), // insert your font size here
                  ),
                ),
                Icon(
                  Icons.person_add,
                  color: Colors.orange,
                  size: 50.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                )
              ]))));
}

Widget exportToPdf(
    BuildContext context, String btnName) {
  //Button to add new Id in the roster
  //PreCond:
  //          1. Requires context of current page,
  //          2. Button name as an string which should not be empty
  //          3. Page function to navigate to the next page
  //
  //PostCond:
  //          1. Add new id Button is displayed on the page
  //          2. On press the button invokes method to export the institution data into a file
  assert(btnName.isNotEmpty);
  return Flexible(
      child: SizedBox(
          height: 100,
          width: 650,
          child: ElevatedButton(
              onPressed: () {
                Config.log
                    .i("User clicked on export data button named: " + btnName);
                exportQrCode('test.pdf',10);
              },
              child: Row(children: <Widget>[
                Text(
                  btnName,
                  style: TextStyle(
                    fontSize: ResponsiveFlutter.of(context)
                        .fontSize(4), // insert your font size here
                  ),
                ),
                Icon(
                  Icons.picture_as_pdf,
                  color: Colors.orange,
                  size: 50.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                )
              ]))));
}
