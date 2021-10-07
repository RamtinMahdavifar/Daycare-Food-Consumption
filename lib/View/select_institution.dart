import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Model/database.dart';
import '../Model/institution_info.dart';
import '../institution_page.dart';
import 'widgets.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';
import 'package:firebase_database/firebase_database.dart'; // need to include for the Event data type
import 'package:plate_waste_recorder/Model/research_group.dart';
import 'package:plate_waste_recorder/Model/researcher_info.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'dart:convert'; // required for jsonDecode()

void main() {
  // TODO: remove database initialization
  // TODO: define dispose() methods for each widget
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // TODO: split pages/screens and widgets into separate files.
    const SelectInstitute(),
  );
}

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
                ])
        )
    );
  }



}