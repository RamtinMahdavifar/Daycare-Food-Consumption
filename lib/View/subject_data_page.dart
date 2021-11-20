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
            subjectDataEntry(),
            subjectDataEntry(),
            subjectDataEntry(),
            subjectDataEntry(),
            subjectDataEntry(),
            subjectDataEntry(),
          ],
        )
      )
    );
  }

  // widget representing a single meal entry for this particular subject
  Widget subjectDataEntry(){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Card(
      color: Colors.blue,
      margin: EdgeInsets.only(top: screenHeight/6, bottom: screenHeight/6, left: 20, right: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(width: screenWidth/4,
                  child: Center(child: Text("Meal", style: TextStyle(fontSize: 30.0, color: Colors.white),)),
                  // TODO: consider using Image.network(url) to display images right off of google drive
              ),
              SizedBox(height: 30,), // add sizedBox to separate elements
              OutlinedButton(onPressed: ()=>{}, style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
                  child: Text("View Details", style: TextStyle(fontSize: 20.0, color: Colors.white))),
            ],
          )
      )
    );
  }
}
