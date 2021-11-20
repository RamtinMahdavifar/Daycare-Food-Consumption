import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Helper/icons.dart';
import 'package:plate_waste_recorder/Model/institution.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';
import 'package:responsive_flutter/responsive_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // required for jsonDecode()
import 'package:plate_waste_recorder/Model/database.dart';
import 'package:firebase_database/firebase_database.dart'; // need to include for the Event data type
import 'package:plate_waste_recorder/View/login_page.dart';



Widget RosterRecord(BuildContext context, String btnName, Widget Function() page, String StudentID){

  return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent,style: BorderStyle.solid ,width: 5.0)
      ),

      child: Row(

          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            ElevatedButton(

              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return page();
                    }));

              },
              style: ElevatedButton.styleFrom(
                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  // textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),

                  primary: Colors.red,
                  ),

              child: Icon(
                Icons.highlight_remove,
                color: Colors.black,
                size: 60.0,

              ),

            ),SizedBox(width: 200),
            Text(StudentID, style: TextStyle(fontSize: 40)),
            SizedBox(width: 200),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context){
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
            SizedBox(width: 180),
            ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context){
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


            ]

      )
  );

}

Widget addNewId(BuildContext context, String btnName, Widget Function() page){
  return Flexible(

      child: SizedBox(
          height: 100,
          width: 650,

          child: ElevatedButton(


              onPressed: () {  Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return page();
                  })); },
              child:Row(
                  children:  <Widget>[

                    Text(btnName,
                      style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(4),// insert your font size here
                      ),),

                    Icon(
                      Icons.person_add,
                      color: Colors.orange,
                      size: 50.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    )

                  ]

              )
          )

      )
  );
}

Widget exportToPdf(BuildContext context, String btnName, Widget Function() page){
  return Flexible(

      child: SizedBox(
          height: 100,
          width: 650,

          child: ElevatedButton(


              onPressed: () {  Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return page();
                  })); },
              child:Row(
                  children:  <Widget>[

                    Text(btnName,
                      style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(4),// insert your font size here
                      ),),

                    Icon(
                      Icons.picture_as_pdf,
                      color: Colors.orange,
                      size: 50.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    )

                  ]

              )
          )

      )
  );
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
            List<Widget> children;
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
                  // TODO: consider displaying something else here, ex an error message indicating no database connection
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
                    Text("No Subjects Have Yet Been Created, be the First to Create One Below",
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
                    // create a roster record out of each SubjectInfo we have in this institution
                    children = retrievedInstitution.subjectsMap.values.map((value)=>RosterRecord(context, "", ()=>LoginPage(), value.subjectId)).toList();

                    // display these read in subjects in a listview
                    return ListView(children: children);
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

