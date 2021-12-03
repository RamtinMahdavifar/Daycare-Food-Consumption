import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Helper/icons.dart';
import 'package:plate_waste_recorder/Model/institution.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';
import 'package:plate_waste_recorder/View/subject_data_page.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // required for jsonDecode()
import 'package:plate_waste_recorder/Model/database.dart';
import 'package:firebase_database/firebase_database.dart'; // need to include for the Event data type
import 'package:plate_waste_recorder/Model/subject_info.dart';

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

Widget subjectDisplay(InstitutionInfo currentInstitutionInfo){
  return Flexible(
      fit: FlexFit.loose,
      child: StreamBuilder<Event>(
        // use the ResearchGroup with name testResearchGroupName as a sort of stub
        // as we don't yet have adding/joining research groups implemented
        // TODO: get current ResearchGroup user is in and display it's info here
          stream: Database().getInstitutionStream(currentInstitutionInfo, ResearchGroupInfo("testResearchGroupName")),
          builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
            if (snapshot.hasError) {
              Config.log.e("errors occurred while reading subjects from the database on roster page, error: " + snapshot.error.toString());
              return Text("errors in database read occurred");
            }
            else {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  Config.log.w("connection state none when reading subjects from the database");
                  // display a loading animation here, this will continue until we are
                  // able to connect to the database
                  return Center(child: CircularProgressIndicator(
                    value: null,
                    color: Colors.green,
                  ));
                  break;
                case ConnectionState.waiting:
                  Config.log.i("connection state waiting when reading subjects from the database");
                  // include a waiting animation while we connect to the database
                  // value: null here indicates that the progress animation will
                  // continue forever, until we read data from the database
                  return Center(child: CircularProgressIndicator(
                    value: null,
                    color: Colors.green,
                  ));
                  break;
                case ConnectionState.active:
                  Config.log.i("active connection state when reading subjects from the database");
                  DataSnapshot institutionSnapshot = snapshot.data!.snapshot;
                  if(institutionSnapshot.value == null){
                    // if the retrieved institutionSnapshot contains null ie
                    // doesn't have any data, there are no subjects
                    // present on the database for the current institution
                    // display a message indicating this
                    Config.log.w("DataSnapshot has null value when reading subjects from the database, ie no institution objects are read");
                    return Center(child:
                    Text("No Subjects Have Yet Been Created For This Institution",
                        style: TextStyle(fontSize: 28.0))
                    );
                  }
                  else{
                    // otherwise we do have subjects on the database, display these
                    Config.log.i("Subjects present in DataSnapshot, displaying these");
                    Map<dynamic, dynamic> snapshotValueMap = institutionSnapshot.value as Map<dynamic,dynamic>;
                    String encodedMap = jsonEncode(snapshotValueMap);
                    Map<String, dynamic> institutionJSON = json.decode(
                        encodedMap) as Map<String,dynamic>;
                    // convert our read in JSON to an Institution object, display the subjects of this
                    // Institution
                    Institution retrievedInstitution = Institution.fromJSON(institutionJSON);
                    Map<String, SubjectInfo> subjectsMap = retrievedInstitution.subjectsMap;

                    if(subjectsMap.isEmpty){
                      // we don't have any subjects for the institution, display this
                      return Center(child:
                      Text("No Subjects Have Yet Been Created For This Institution",
                          style: TextStyle(fontSize: 28.0))
                      );
                    }
                    else{
                      // we do have subjects for this institution, create a roster record out of
                      // each SubjectInfo we have in this institution clicking on each of these roster records
                      // will take us to the subject data page for that individual on the roster
                      // get all ids of the subjects in this institution in a sorted order for nicer display
                      List<String> sortedSubjectIDs = retrievedInstitution.subjectsMap.keys.toList();
                      Config.log.i(sortedSubjectIDs);
                      sortedSubjectIDs.sort();
                      Config.log.i(sortedSubjectIDs);
                      List<Widget> sortedSubjectRecords = sortedSubjectIDs.map((id){
                        return RosterRecord(context, "", ()=>SubjectDataPage(currentInstitutionInfo, retrievedInstitution.getInstitutionSubject(id)!), id);
                      }).toList();

                      // display these read in subjects in a listview
                      return ListView(children: sortedSubjectRecords);
                    }
                  }
                  break;
                case ConnectionState.done:
                  Config.log.i("connection state done when reading institutions from the database");
                  return Text("connection state done");
                  break;
              }
            }
          })
  );

}

