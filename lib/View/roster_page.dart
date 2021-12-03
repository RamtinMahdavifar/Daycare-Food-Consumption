import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/View/roster_page_widget.dart';
import 'package:plate_waste_recorder/View/qrcode.dart';


class Roster extends StatefulWidget {
  //Display a list of all the student/QR id in a institution
  //Along with the the id's buttons to edit,view or delete a id record is available
  @override
  State<Roster> createState() => _RosterState();
}

class _RosterState extends State<Roster> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Roster'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                //At the top of page page list all the ids and their methods in the roster format
                child: ListView(children: <Widget>[
              RosterRecord(
                  context, "Type 3", () => QRcode("ID 0"), "0000000123"),
              RosterRecord(
                  context, "Type 3", () => QRcode("ID 1"), "0000000456"),
              RosterRecord(
                  context, "Type 3", () => QRcode("ID 2"), "0000000123"),
              RosterRecord(
                  context, "Type 3", () => QRcode("ID 3"), "0000000456"),
              RosterRecord(
                  context, "Type 3", () => QRcode("ID 4"), "0000000123"),
              RosterRecord(
                  context, "Type 3", () => QRcode("ID 5"), "0000000456"),
              RosterRecord(
                  context, "Type 3", () => QRcode("ID 6"), "0000000123"),
              RosterRecord(
                  context, "Type 3", () => QRcode("ID 7"), "0000000456"),
            ])),
            SizedBox(

                //At the bottom of page show button to add a new ID and export the data
                height: 100,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      addNewId(context, "Add new ID ", () => QRcode("Test")),
                      SizedBox(width: 10),
                      exportToPdf(
                          context, "Export QR to PDF ", () => QRcode("Test")),
                    ]))
          ],
        ));
  }
}
