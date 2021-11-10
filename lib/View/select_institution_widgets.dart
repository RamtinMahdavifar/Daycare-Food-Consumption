import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Model/database.dart';
import 'package:plate_waste_recorder/View/upload_data.dart';
import '../Model/institution.dart';
import 'add_institutions_form.dart';
import 'institution_page.dart';
import 'camera_food.dart';
import 'qrcode.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';
import 'package:firebase_database/firebase_database.dart'; // need to include for the Event data type
import 'package:plate_waste_recorder/Model/research_group.dart';
import 'dart:convert'; // required for jsonDecode()
import 'package:plate_waste_recorder/Helper/config.dart';


//select_institution page button which navigates to that desired institution_page
Widget listedInst(BuildContext context, String name, String address){
  return Card(
      child: ListTile(
          onTap: (){
            Config.log.i("navigating to institution with name: " + name + " and address: " + address);
            // pass the name of the clicked on institution to the daycare screen
            Navigator.push(context, MaterialPageRoute(
                builder: (context){
                  return InstitutionPage(name, address);
                }));
          },
          leading: const Icon(Icons.flight_land_rounded),
          title: Text(name)
      )
  );
}

//simple button, on press opens the dialog to add info for new inst.
Widget addInstitution(BuildContext context){
  return InkWell(
    onTap: (){
      Config.log.i("Add institution button clicked");
      showDialog(
          context: context,
          builder: (context) {
            //return enterSchoolForm(context);
            return AddInstitutionForm();
          }
      );
    }, //pop up form entry window
    child: Card(
        shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
        ),
        color: Colors.green,
        elevation: 2,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                      height: 55,
                      width: 30,
                      child: const Icon(
                          Icons.add,
                          color: Colors.white)
                  )
              ),
              const Expanded(
                  flex: 3,
                  child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text("Add Institution", style: TextStyle(fontSize: 25, color: Colors.white))
                  )
              )
            ]
        )
    ),
  );
}

Widget searchInstitution(){
  Icon icon = Icon(Icons.search);
  return Flexible(
    child: Card(
        color: Colors.white60,
        elevation: 2,
        child: ListTile(
            leading: icon,
            onTap: (){

            },
            title: Text("Search Institutions"))),
  );
}

Widget institutionDisplay(BuildContext context) {
  return Flexible(
      fit: FlexFit.loose,
      child: StreamBuilder<Event>(
        // use the ResearchGroup with name testResearchGroupName as a sort of stub
        // as we don't yet have adding/joining research groups implemented
        // TODO: get current ResearchGroup user is in and display it's info here
          stream: Database().getResearchGroupStream(
              ResearchGroupInfo("testResearchGroupName")),
          builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
            List<Widget> children;
            if (snapshot.hasError) {
              children = <Widget>[Text("errors in database read occured")];
              Config.log.e("errors occured while reading institutions from the database on institution page, error: " + snapshot.error.toString());
            }
            else {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  children = <Widget>[Text("connection state none")];
                  Config.log.w("connection state none when reading institutions from the database");
                  // TODO: include a network error message or read local data
                  break;
                case ConnectionState.waiting:
                  Config.log.i("connection state waiting when reading institutions from the database");
                  children = <Widget>[Text("connection state waiting")];
                  // TODO: include a loading or progress bar
                  break;
                case ConnectionState.active:
                  Config.log.i("active connection state when reading institutions from the database");
                // TODO: see about using async database function to return a ResearchGroup to do all this
                // TODO: instead of having to have the below code to create a ResearchGroup here
                  DataSnapshot researchGroupSnapshot = snapshot.data!.snapshot;
                  Map<dynamic, dynamic> testMap = researchGroupSnapshot.value as Map<dynamic,dynamic>;
                  String encodedMap = jsonEncode(testMap);

                  Map<String, dynamic> researchGroupJSON = json.decode(
                      encodedMap
                  ) as Map<String,dynamic>;
                  ResearchGroup retrievedResearchGroup = ResearchGroup.fromJSON(
                      researchGroupJSON);
                  children = retrievedResearchGroup.institutionsMap.values.map(
                          (institution) =>
                          listedInst(context, institution.name,
                              institution.institutionAddress)
                  ).toList();
                  break;
                case ConnectionState.done:
                  Config.log.i("connection state done when reading institutions from the database");
                  children = <Widget>[Text("connection state done")];
                  break;
              }
            }
            return ListView(
                children: children
            );
          })
  );
}

//used if the database breaks, a bandaid solution to allow me to go to any screen nessessary
Widget quickfixButton(BuildContext context){
  return InkWell(
      onTap: (){
        // pass the name of the clicked on institution to the daycare screen
        Navigator.push(context, MaterialPageRoute(
            builder: (context){

              return MyHome();
            }));
      },
      child: Icon(Icons.edit)
  );
}