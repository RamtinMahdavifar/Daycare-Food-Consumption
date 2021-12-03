import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/View/qrcode.dart';
import 'package:plate_waste_recorder/View/roster_page_widgets.dart';

class Roster extends StatefulWidget {
  // take the Info of the current institution as a parameter to this page
  InstitutionInfo currentInstitution;

  Roster(this.currentInstitution, {Key? key}) : super(key: key);

  @override
  State<Roster> createState() => _RosterState();
}

class _RosterState extends State<Roster> {
  @override
  Widget build(BuildContext context) {
    Config.log.i("building roster page");
    return Scaffold(
        appBar: AppBar(
          title: Text('Roster'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: subjectDisplay(widget.currentInstitution)),
            SizedBox(

                //At the bottom of page show button to add a new ID and export the data
                height: 100,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      addNewId(context, "Add new ID ", () => MyHome("Test")),
                      SizedBox(width: 10),
                      exportToPdf(context, "Export QR to PDF "),
                    ]))
          ],
        ));
  }
}
