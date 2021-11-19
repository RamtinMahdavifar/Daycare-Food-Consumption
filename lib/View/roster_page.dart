import 'package:flutter/material.dart';
import 'select_institution_widgets.dart';
import 'package:plate_waste_recorder/View/roster_page_widget.dart';
import 'package:plate_waste_recorder/View/qrcode.dart';
import 'package:plate_waste_recorder/View/login_page.dart';
class Roster extends StatefulWidget {
  @override
  State<Roster> createState() => _RosterState();
}

class _RosterState extends State<Roster> {
  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Roster'),),
      body: Column(
          children: <Widget>[  Expanded(
          child: ListView(

              children: <Widget>[
                RosterRecord(context,"Type 3",()=>LoginPage(),"0000000123"),
                RosterRecord(context,"Type 3",()=>LoginPage(),"0000000456"),
                RosterRecord(context,"Type 3",()=>LoginPage(),"0000000123"),
                RosterRecord(context,"Type 3",()=>LoginPage(),"0000000456"),
                RosterRecord(context,"Type 3",()=>LoginPage(),"0000000123"),
                RosterRecord(context,"Type 3",()=>LoginPage(),"0000000456"),
                RosterRecord(context,"Type 3",()=>LoginPage(),"0000000123"),
                RosterRecord(context,"Type 3",()=>LoginPage(),"0000000456"),

              ])
      ),SizedBox(
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