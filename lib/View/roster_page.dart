import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'select_institution_widgets.dart';
import 'package:plate_waste_recorder/View/roster_page_widget.dart';
import 'package:plate_waste_recorder/View/qrcode.dart';
import 'package:plate_waste_recorder/View/login_page.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text('Roster'),),
      body: Column(
          children: <Widget>[
            Expanded(child: subjectDisplay(widget.currentInstitution)),
            SizedBox(
              height: 100,
              child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                addNewId(context, "Add new ID ", () => LoginPage()),
                SizedBox(width: 10),
                exportToPdf(context, "Export QR to PDF ", () => LoginPage()),
            ]

    )

          )],

    ));
  }

}