import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Model/database.dart';

import 'widgets.dart';



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
  // define controllers for the form fields we'll have when adding new institutions
  //final _newInstitutionNameController = TextEditingController();
  //final _newInstitutionAddressController = TextEditingController();
  //final _formKey = GlobalKey<FormState>();
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