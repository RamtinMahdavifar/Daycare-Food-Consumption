import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Model/drive_access.dart';
import 'package:plate_waste_recorder/Model/food_status.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';
import 'package:plate_waste_recorder/View/roster_page.dart';

import 'id_input_page.dart';

class ViewDataPage extends StatefulWidget {
  //Takes the institution name and address to render a page
  // with options to view the data in different ways
  String institutionName;
  String institutionAddress;

  //Renders the view data menu as an page with the institution name and address
  ViewDataPage(this.institutionName, this.institutionAddress, {Key? key})
      : super(key: key);

  @override
  _ViewDataPageState createState() => _ViewDataPageState();
}

class _ViewDataPageState extends State<ViewDataPage> {
  @override
  Widget build(BuildContext context) {
    Config.log.i("building view data page");
    return Scaffold(
        appBar: AppBar(title: Text('View Data For Institution: ${widget.institutionName}')),
      body: Center(
          child: Column(
              children: <Widget>[
                // add an empty SizedBox between column elements
                // to create space between elements
                SizedBox(height: 80.0),
                ViewDataOption("Scan QR Code", (){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: const Duration(seconds: 2),content: Text(
                      "Work in Progress ")));
                }),
                SizedBox(height: 80.0),
                ViewDataOption("Select From Roster", (){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: const Duration(seconds: 2),content: Text(
                      "Work in Progress ")));

                }),
                SizedBox(height: 80.0),
                ViewDataOption("Export Data", (){
                  Config.log.i("User has clicked to export institution ${widget.institutionName} data");
                  DriveAccess().exportDataToDrive(ResearchGroupInfo("testResearchGroupName"), InstitutionInfo(widget.institutionName, widget.institutionAddress));
                  Config.log.i("data export complete...");
                }),
              ]
          )
      )
    );
  }

  Widget ViewDataOption(String optionName, void Function() tapFunction){
    assert(optionName.isNotEmpty);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Card(
        child: SizedBox(width: screenWidth*0.625, height: screenHeight*0.15,
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
              tileColor: Colors.green,
              title: Center(child: Text(optionName)),
              onTap: (){
                Config.log.i("User selected the option: $optionName");
                tapFunction();
              },
            )
        )
    );
  }
}
