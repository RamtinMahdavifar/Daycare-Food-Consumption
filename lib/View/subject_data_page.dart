import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';


class SubjectDataPage extends StatefulWidget {
  InstitutionInfo currentInstitution;
  SubjectInfo currentSubject;
  SubjectDataPage(this.currentInstitution, this.currentSubject, {Key? key}) : super(key: key);

  @override
  _SubjectDataPageState createState() => _SubjectDataPageState();
}

class _SubjectDataPageState extends State<SubjectDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Data for Subject: ${widget.currentSubject.subjectId}")),
      body: Container(
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[

          ],
        )
      )
    );
  }

  // widget representing a single meal entry for this particular subject
  Widget subjectDataEntry(){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        children: <Widget>[
          Center(child: Text("Meal 1")),
          // TODO: consider using Image.network(url) to display images right off of google drive
          OutlinedButton(onPressed: ()=>{}, child: Text("View Details"))
        ],
      )
    );
  }
}
