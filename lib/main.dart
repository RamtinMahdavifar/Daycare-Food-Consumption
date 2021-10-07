import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Model/database.dart';
//import 'Model/institution.dart';
//import 'institution_page.dart';
import 'package:plate_waste_recorder/View/select_institution.dart';
//import 'View/select_institution.dart';
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

