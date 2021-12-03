import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/View/roster_page.dart';
import 'package:plate_waste_recorder/View/view_data_page.dart';

import 'food_status_page.dart';
import 'institution_page_widgets.dart';
import 'qr_scan_id.dart';

class InstitutionPage extends StatefulWidget {
  //Display a buttons like roster, view data to perform operations for a institution

  String institutionName;
  String institutionAddress;

  InstitutionPage(this.institutionName, this.institutionAddress, {Key? key})
      : super(key: key);

  @override
  State<InstitutionPage> createState() => _InstitutionPageState();
}

class _InstitutionPageState extends State<InstitutionPage> {
  @override
  Widget build(BuildContext context) {
    Config.log.i("building institution page");
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.institutionName.toString()),
          leading: backButton(context),
          actions: [modifyButton()]),
      body: _InstitutionOptions(),
    );
  }

  Widget _InstitutionOptions() {
    return SafeArea(
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
              child: Text("Address: " + widget.institutionAddress,
                  style: TextStyle(fontSize: 40))),
          Expanded(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Navigates to roster page
                    menuButton(context, "Roster", () => Roster(widget.institutionName), 2),
                    //idx 2: is the position of roster icon in list of icon categories
                    SizedBox(width: 50),
                    //Navigates to preset page page
                    menuButton(context, "Preset", () => QR_ScanID(), 0),
                    //idx 0: is the position of preset icon in list of icon categories
                  ],
                )),
          ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //most of the buttons do not navigate anywhere and have null as their navigation parameter

                    //Navigates to view data page
                    menuButton(
                        context,
                        "View Data",
                        () => ViewDataPage(
                            widget.institutionName, widget.institutionAddress),
                        3),
                    //idx 3: is the position of View Data icon in list of icon categories
                    SizedBox(width: 50),
                    //Navigates to Input data
                    menuButton(
                        context, "Input Data", () => FoodStatusPage(), 1),
                    //idx 1: is the position of preset Input in list of icon categories
                  ],
                )),
          ),
        ],
      )),
    );
  }
}
