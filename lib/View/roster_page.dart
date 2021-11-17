import 'package:flutter/material.dart';
import 'select_institution_widgets.dart';
import 'package:plate_waste_recorder/View/roster_page_widget.dart';
import 'package:plate_waste_recorder/View/qrcode.dart';
class Roster extends StatefulWidget {
  @override
  State<Roster> createState() => _RosterState();
}

class _RosterState extends State<Roster> {
  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Roster')),
      body: Container(
        // margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
              children: <Widget>[
                RosterRecord(context,"Type 3",()=>MyHome(),"0000000123"),
                RosterRecord(context,"Type 3",()=>MyHome(),"0000000456"),
                RosterRecord(context,"Type 3",()=>MyHome(),"0000000789"),
                RosterRecord(context,"Type 3",()=>MyHome(),"0000000123"),
                RosterRecord(context,"Type 3",()=>MyHome(),"0000000456"),
                RosterRecord(context,"Type 3",()=>MyHome(),"0000000789"),
                RosterRecord(context,"Type 3",()=>MyHome(),"0000000123"),
                RosterRecord(context,"Type 3",()=>MyHome(),"0000000456"),
                RosterRecord(context,"Type 3",()=>MyHome(),"0000000789"),
              ])
      ),

    );
  }

}