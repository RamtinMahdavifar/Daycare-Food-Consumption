import 'package:flutter/material.dart';
//import 'package:plate_waste_recorder/Model/database.dart';
import 'select_institution_widgets.dart';



class SelectInstitute extends StatelessWidget {
  const SelectInstitute({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Plate Waste Tracker',
        home: ChooseInstitute()
    );
  }
}

class ChooseInstitute extends StatefulWidget {
  @override
  State<ChooseInstitute> createState() => _ChooseInstituteState();
}

class _ChooseInstituteState extends State<ChooseInstitute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Plate Waste Tracker')),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
                children: [ // TODO: move these child widgets to their own files
                  addInstitution(context),
                  searchInstitution(),
                  institutionDisplay(context),
                  quickfixButton(context)
                ])
        )
    );
  }



}