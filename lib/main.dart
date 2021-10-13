import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/View/select_institution.dart';


void main() {
  // TODO: remove database initialization
  // TODO: define dispose() methods for each widget
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // TODO: split pages/screens and widgets into separate files.
    const SelectInstitute(),
  );
}

